// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;
import "./LicenseLib.sol";


interface ILicenseRegistry {
    /**
    * @dev emitted when new content type added
    * @param contentType contract type
    */
    event contentTypeAdded(bytes32 contentType);

    /**
    * @dev emitted when new license type added
    * @param templateId templateIding Id
    * @param licenseType license type Id
    */
    event licenseTypeAdded(bytes32 templateId,bytes32 licenseType);
    /**
    * @dev emitted when new license contract added
    * @param licenseType license type
    * @param contractAddress address of contract
    */
    event licenseContractAdded(bytes32 licenseType,address contractAddress,bytes4[] actions);

    event licenseCallDataUpdated(bytes32 license,bytes32 action,bytes4 oldAction,bytes4 newAction);
    event actionDataUpdated(bytes32[]  _actions, LicenseLib.ActionCat actionType,LicenseLib.ActionReturn actionReturn);
    event actionDataAdded(bytes32 action,LicenseLib.ActionCat actionType,LicenseLib.ActionReturn actionReturn);



    /**
    * @dev external function to add license contract
    * @param _contractAddress address of deployed contract
    * @param _actions action functions' signature of the contract
    * @param _contentType which contentType is the license contract devployed for
    * @param _licenseType which licenseType is the license contract devployed for
    */ 
    function addLicenseContract(
        address _contractAddress,
        bytes4[] calldata _actions,
        bytes32 _contentType,
        bytes32 _licenseType,
        uint96 _templateId
    ) external;


    /**
    * @dev external function to add license type
    * @param _name name of license
    * @param _contentType name of content type
    */ 
    function addLincenseType(
        bytes32 _name,
        bytes32 _contentType
    ) external;
    /**
    * @dev external function to add content type
    * @param _contentType name of content type
    */ 
    function addContentType(
        bytes32 _contentType
    ) external;
}