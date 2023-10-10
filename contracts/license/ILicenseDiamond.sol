// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.6;


interface ILicenseDiamond {

    /**
    * @dev enum for actions on modifiying, pausing or deleting the offer
    */
    enum Actions{
        UpdateLicenseProposal, //0
        DeleteLicenseProposal,//1
        PauseLicenseProposal,//2
        UpdateLicenseOffer,//3
        DeleteLicenseOffer,//4
        PauseLicenseOffer,//5
        acceptProposal,//6
        acceptOffer,//7
        UpdateLicense,//8
        cancelLicense //9
    }
    

    /**
    * @dev emitted when new content type added
    * @param contentType contract type
    */
    event cotentTypeAdded(bytes32 contentType);

    /**
    * @dev emitted when new license type added
    * @param versioning versioning Id
    * @param licenseType license type Id
    */
    event licenseTypeAdded(bytes32 versioning,bytes32 licenseType);
    /**
    * @dev emitted when new license contract added
    * @param licenseType license type
    * @param contractAddress address of contract
    */
    event licenseContractAdded(bytes32 licenseType,address contractAddress);


    /**
    * @dev external function to initialize the contract
    * @param _accessRestrictionAddress access contract address
    */ 
    function initialize(
        address _accessRestrictionAddress
    ) external;

    /**
    * @dev external function to add license contract
    * @param _contractAddress address of deployed contract
    * @param _contentType which contentType is the license contract devployed for
    * @param _licenseType which licenseType is the license contract devployed for
    */ 
    function addLicenseContract(
        address _contractAddress,
        string memory _contentType,
        string memory _licenseType,
        uint96 _version
    ) external;


    /**
    * @dev external function to add license type
    * @param _name name of license
    * @param _contentType name of content type
    */ 
    function addLincenseType(
        string memory _name,
        string memory _contentType
    ) external;
    /**
    * @dev external function to add content type
    * @param _contentType name of content type
    */ 
    function addContentType(
        string memory _contentType
    ) external;
}