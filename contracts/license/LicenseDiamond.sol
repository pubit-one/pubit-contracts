// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.6;

import "./ILicenseDiamond.sol";
import "../access/IAccessRestriction.sol";
import "./LicenseLib.sol";
contract LicenseDiamond is ILicenseDiamond{

    IAccessRestriction public accessRestriction;

    mapping ( bytes32=>bool ) contentTypes;
    mapping ( bytes32=>uint96 ) licenseVersioning;
    mapping ( bytes32=>LicenseLib.LicenceMetadata ) licenses;
    
    /** NOTE modifier to check msg.sender has admin role */
    modifier onlyAdmin() {
        accessRestriction.ifAdmin(msg.sender);
        _;
    }
    
    function initialize(
        address _accessRestrictionAddress
    ) external{
        IAccessRestriction candidateContract = IAccessRestriction(
            _accessRestrictionAddress
        );
        require(candidateContract.isAccessRestriction());
        accessRestriction = candidateContract;
    };



    function addLicenseContract(
        address _contractAddress,
        string memory _contentType,
        string memory _licenseType,
        uint96 _version
    ) external onlyAdmin() {
        uint size;
        assembly { size := extcodesize(addr)}
        if(size==0){
            revert LicenseLib.InvalidContractAddress(_contractAddress);
        }
        bytes32 id=keccak256(bytes32(_contentType),bytes32(_licenseType),_version);

        if (licenses[id].version==0){
            revert LicenseLib.LicenseTypeNotSupported(id);
        }
        if (licenses[id].contractAddress!=address(0)){
            revert LicenseLib.ContractExistsForLicense(id);
        }
        license[id].contractAddress=_contractAddress;
        emit licenseContractAdded(id,_contractAddress);
    }


    function addLincenseType(
        string memory _licenseType,
        string memory _contentType
    ) external onlyAdmin() {
        if (!contentTypes[bytes32(_contentType)]){
            revert LicenseLib.ContentTypeNotSupported(bytes32(_contentType));
        }
        bytes32 vId=keccak256(bytes32(_contentType),bytes32(_licenseType));
        uint96 v=licenseVersioning[vId]+1;
        licenseVersioning[vId]=v;
        bytes32 id=keccak256(bytes32(_contentType),bytes32(_licenseType),v);
        licenses[id]=LicenseLib.LicenceMetadata(bytes32(_contentType),bytes32(_licenseType),address(0),v);
        emit licenseTypeAdded(vid,id);
    }

    function addContentType(
        string memory _contentType
    ) external onlyAdmin() {
        if (contentTypes[bytes32(_contentType)]){
            revert LicenseLib.ContentTypeExists(bytes32(_contentType));
        }
        contentTypes[bytes32(_contentType)] =true;
        emit contentTypeAdded(bytes32(_contentType));
    }
}