// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

import "./ILicenseRegistry.sol";
import "../access/IAccessRestriction.sol";
import "./LicenseLib.sol";
contract LicenseRegistry is ILicenseRegistry{

    IAccessRestriction public accessRestriction;
    bytes32[]  public actions;
    mapping(  bytes32=>LicenseLib.ActionData ) public actionData;
    mapping ( bytes32=>bool ) public contentTypes;
    mapping ( bytes32=>uint96 ) public licenseTemplates;
    mapping ( bytes32=>LicenseLib.LicenseMetadata ) public licenseTypes;
    mapping (address =>bytes32)  public licenseContracts;
    mapping( address=>mapping( bytes32=>bytes4 ) ) public licenseActions;
    mapping( address=>mapping( bytes4=>bytes32 ) ) public actionUsages;
    
    /** NOTE modifier to check msg.sender has admin role */
    modifier onlyAdmin() {
        accessRestriction.ifAdmin(msg.sender);
        _;
    }
    
    constructor(
        address _accessRestrictionAddress
    )  {
        IAccessRestriction candidateContract = IAccessRestriction(
            _accessRestrictionAddress
        );
        if(!candidateContract.isAccessRestriction()){
            revert LicenseLib.InvalidAccessRestriction(_accessRestrictionAddress);
        }
        accessRestriction = candidateContract;
        _init_actionData();
    }



    function addLicenseContract(
        address _contractAddress,
        bytes4[] calldata _actions,
        bytes32 _contentType,
        bytes32 _licenseType,
        uint96 _templateId
    ) external onlyAdmin() {
        if (licenseContracts[_contractAddress].length > 0) {
            revert LicenseLib.ContractAddressExist(_contractAddress);
        }
        uint size;
        assembly { size := extcodesize(_contractAddress)}
        if(size==0){
            revert LicenseLib.InvalidContractAddress(_contractAddress);
        }
        bytes32 id=keccak256(abi.encode(_contentType,_licenseType,_templateId));
        if (licenseTypes[id].templateId==0){
            revert LicenseLib.LicenseTypeNotSupported(id);
        }
        if (_actions.length>actions.length) {
            revert LicenseLib.ActionCountExeeded(_actions.length);
        }
        licenseTypes[id].contractAddress=_contractAddress;
        licenseContracts[_contractAddress]=id;
        for(uint i=0;i<_actions.length;i++){
            if(actionUsages[_contractAddress][_actions[i]]!=bytes32(0) &&_actions[i]!=bytes4(0)){
                revert LicenseLib.ActionUsedBefore(_contractAddress,_actions[i]);
            }
            licenseActions[_contractAddress][actions[i]]=_actions[i];
            actionUsages[_contractAddress][_actions[i]]=actions[i];
        }
        emit licenseContractAdded(id,_contractAddress,_actions);
    }

    function updateLicenseActions(bytes32 _license,bytes4 _action,bytes32 _type) external onlyAdmin(){
        address _contractAddress=licenseTypes[_license].contractAddress;
        if (licenseContracts[_contractAddress].length ==0) {
            revert LicenseLib.InvalidContractAddress(_contractAddress);
        }
        if(actionUsages[_contractAddress][_action]!=bytes32(0)){
                revert LicenseLib.ActionUsedBefore(_contractAddress,_action);
        }
        bytes4 old=licenseActions[_contractAddress][_type];
        licenseActions[_contractAddress][_type]=_action;
        actionUsages[_contractAddress][old]=_type;
        actionUsages[_contractAddress][_action]=_type;
        emit licenseCallDataUpdated(_license,_type,old,_action);
    }

    function addLincenseType(
        bytes32 _licenseType,
        bytes32 _contentType
    ) external onlyAdmin() {
        if (!contentTypes[bytes32(_contentType)]){
            revert LicenseLib.ContentTypeNotSupported(bytes32(_contentType));
        }
        bytes32 tId=keccak256(abi.encode(_contentType,_licenseType));
        uint96 v=licenseTemplates[tId]+1;
        licenseTemplates[tId]=v;
        bytes32 id=keccak256(abi.encode(_contentType,_licenseType,v));
        licenseTypes[id]=LicenseLib.LicenseMetadata(_contentType,_licenseType,address(0),v);
        emit licenseTypeAdded(tId,id);
    }

    function addContentType(
        bytes32 _contentType
    ) external onlyAdmin() {
        if (contentTypes[bytes32(_contentType)]){
            revert LicenseLib.ContentTypeExists(bytes32(_contentType));
        }
        contentTypes[bytes32(_contentType)] =true;
        emit contentTypeAdded(bytes32(_contentType));
    }

    function getLicenseContracts(bytes32 _license) external view returns(LicenseLib.LicenseMetadata memory,bytes4[] memory){
        bytes4[] memory _actions=new bytes4[](actions.length);
        for (uint i=0;i<actions.length;i){
            _actions[i]=licenseActions[licenseTypes[_license].contractAddress][actions[i]];
        }
        return(licenseTypes[_license],_actions);
    }

    function getLicenseActions(bytes32 _license,bytes32 _action) external view returns(bytes4){
        return licenseActions[licenseTypes[_license].contractAddress][_action];
    }

    function addActionData(bytes32 _action, LicenseLib.ActionCat _actionType, LicenseLib.ActionReturn _actionReturn ) external onlyAdmin(){
        if(!actionData[_action].exists){
            revert LicenseLib.ActionAlreadyExists(_action);
        }
        bytes32[] memory _actions=actions;
        uint128 ind= uint128(_actions.length);
        actions.push(_action);
        actions=_actions;
        actionData[_action]=LicenseLib.ActionData(ind,_actionType,_actionReturn,true,0,0,0);
        emit actionDataAdded(_action,_actionType,_actionReturn);
    }

    function _init_actionData() internal{
        bytes32[18] memory _ac=[
        bytes32("Fallback"),
        bytes32("CreateItem"),
        bytes32("UpdateItem"),
        bytes32("CancelItem"),
        bytes32("PauseItem"),
        bytes32("ResumeItem"),
        bytes32("CreateOffer"),
        bytes32("CancelOffer"),
        bytes32("BuyLicense"),
        bytes32("AcceptOffer"),
        bytes32("ChangeLicense"),
        bytes32("AcceptChange"),
        bytes32("UpgradeLicense"),
        bytes32("CancelLicense"),
        bytes32("BlockLicense"),
        bytes32("InvalidateLicense"),
        bytes32("Checklicense"),
        bytes32("CheckStatus") 
        ];
        actionData[_ac[0]]=LicenseLib.ActionData(0,LicenseLib.ActionCat.Default,LicenseLib.ActionReturn.Data,true,0,0,0);
        bytes32[] memory _actions;
        _actions[0]=_ac[0];
        for(uint128 i=1;i<_ac.length;i++){
            _actions[i]=_ac[i];
            if(i<8){
                actionData[_ac[i]]=LicenseLib.ActionData(i,LicenseLib.ActionCat.PreActions,LicenseLib.ActionReturn.Bool,true,0,0,0);
            }
            else if(i<10){
                actionData[_ac[i]]=LicenseLib.ActionData(i,LicenseLib.ActionCat.GenActions,LicenseLib.ActionReturn.Index,true,0,0,0);
            }
            else if(i<16){
                actionData[_ac[i]]=LicenseLib.ActionData(i,LicenseLib.ActionCat.PostActions,LicenseLib.ActionReturn.Status,true,0,0,0);
            }
            else{
                actionData[_ac[i]]=LicenseLib.ActionData(i,LicenseLib.ActionCat.ViewActions,LicenseLib.ActionReturn.Data,true,0,0,0);
            }
        }
        actions=_actions;
    }

    function setActionData(bytes32[] memory _actions,LicenseLib.ActionCat _actionType, LicenseLib.ActionReturn _actionReturn) external onlyAdmin() {
        for(uint i=0;i<_actions.length;i++){
            if(actionData[_actions[i]].exists){
                actionData[_actions[i]].actionType=_actionType;
                actionData[_actions[i]].actionReturn=_actionReturn;
            }
        }
        emit actionDataUpdated(_actions,_actionType,_actionReturn);
    }
    

}