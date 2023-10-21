// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.20;

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

    enum licenseTypestatus {
        NotExists, //0
        Expired, //1
        Canceled, //2
        Blocked, //3
        Invalid, //4
        Active //5
    }
    enum ItemStatus {
        NotExists, //0
        Created,
        Paused,
        Expired,
        Deleted,
        Active
    }
    enum ActionCat {
        Default,
        PreActions,
        GenActions,
        PostActions,
        ViewActions
    }
    enum ActionReturn {
        NoReturn,
        Bool,
        Index,
        Status,
        Data
    }
    error ContentTypeExists(bytes32 _contentType);
    error ContentTypeNotSupported(bytes32 _contentType);
    error ContractExistsForLicense(bytes32 _licenseType);
    error LicenseTypeNotSupported(bytes32 _licenseType);
    error InvalidContractAddress(address _contractAddress);
    error ContractAddressExist(address _contractAddress);
    error InvalidAccessRestriction(address _contractAddress);
    error ActionUsedBefore(address _contractAddress, bytes4 _action);
    error ActionAlreadyExists(bytes32 _action);
    error ActionCountExeeded(uint arraySize);
    struct LicenseMetadata {
        bytes32 contentType;
        bytes32 licenseType;
        address contractAddress;
        uint96 templateId;
    }
    struct LicenseIds {
        address _contractAddress;
        uint88 id;
        uint8 status;
    }
    struct ActionData {
        uint128 index;
        ActionCat actionType;
        ActionReturn actionReturn;
        bool exists;
        uint32 reserved;
        uint32 reserved2;
        uint32 reserved3;
    }
}
