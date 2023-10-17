// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.6;

library LicenseLib {
    // ContentType {
    //     Text,Audio,Video, Program, Standard, Product, Procedure
    // }
    // TextLicenseType {
    //     Other,Writer,Publisher,OnlinePublisher,Translator,AudioBookProvider,Auditor,Desinger,Adaptor,Libarary,OnlineLiberary,Institute,Refrencer,PartialUser,BriefPublisher,EndUser,
    // }
    // AudioLicenseType {
    //     Other,PoemWriter, Composer, Musician, Singer, Narator, Producer, Publisher, OnlinePublisher, OnlineStreamer, Remixer, Club, OnlineContent, ProfessionalVideo, SocialMedia, PersonalPublish, EndUser,
    // }
    // VideoLicenseType{
    //     Other,Artist, Producer, Publisher, OnlinePublisher, AudioStreamer, PartialUse, PlayChannel, SubTitleProvider, DubPublisher, Dubber, Adaptor, Cinema, Hotels, Transportation, Institutes, EndUser,  
    // }
    // Program{
    //     Other,
    // }
    
    enum LicenseStatus{
        NotExists, //0
        Expired,   //1
        Canceled,  //2
        Blocked,   //3
        Invalid,   //4
        Active,    //5
    }
    enum ItemStatus{
        NotExists, //0
        Paused,
        Expired,
        Deleted,
        Active,
    }
    /**
    * @dev enum for actions on modifiying, pausing or deleting the offer
    */
    enum Actions{
        UpdateItem,
        CancelItem,
        PauseItem,
        ResumeItem,
        CancelOffer,
        BuyLicense,
        AcceptOffer,
        ChangeLicense,
        AcceptChange,
        UpgradeLicense,
        CancelLicense,
        BlockLicense,
        InvalidateLicense,
        Checklicense
    }
    error contentTypeExists(bytes32 _contentType);
    error ContentTypeNotSupported(bytes32 _contentType);
    error ContractExistsForLicense(bytes32 _licenseType);
    error LicenseTypeNotSupported(bytes32 _licenseType);
    error InvalidContractAddress(address _contractAddress);
    error ContractAddressExist(address _contractAddress);
    error InvalidAccessRestriction(address _contractAddress);
    struct LicenceMetadata{
        bytes32 contentType;
        bytes32 licenseType;
        address contractAddress;
        uint96 templateId;
    }
    struct LicenseIds{
        address _contractAddress;
        uint88 id;
        uint8 status;

    }


}