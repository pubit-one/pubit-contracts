// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.6;

library LicenseLib {
    // enum ContentType {
    //     Text,Audio,Video, Program, Standard, Product, Procedure
    // }
    // enum TextLicenseType {
    //     Other,Writer,Publisher,OnlinePublisher,Translator,AudioBookProvider,Auditor,Desinger,Adaptor,Libarary,OnlineLiberary,Institute,Refrencer,PartialUser,BriefPublisher,EndUser,
    // }
    // enum AudioLicenseType {
    //     Other,PoemWriter, Composer, Musician, Singer, Narator, Producer, Publisher, OnlinePublisher, OnlineStreamer, Remixer, Club, OnlineContent, ProfessionalVideo, SocialMedia, PersonalPublish, EndUser,
    // }
    // enum VideoLicenseType{
    //     Other,Artist, Producer, Publisher, OnlinePublisher, AudioStreamer, PartialUse, PlayChannel, SubTitleProvider, DubPublisher, Dubber, Adaptor, Cinema, Hotels, Transportation, Institutes, EndUser,  
    // }
    // enum Program{
    //     Other,
    // }
    error contentTypeExists(bytes32 _contentType);
    error ContentTypeNotSupported(bytes32 _contentType);
    error ContractExistsForLicense(bytes32 _licenseType);
    error LicenseTypeNotSupported(bytes32 _licenseType);
    error InvalidContractAddress(address _contractAddress);
    struct LicenceMetadata{
        bytes32 contentType;
        bytes32 licenseType;
        address contractAddress;
        uint96 version;
    }


}