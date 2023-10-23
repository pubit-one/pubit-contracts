// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

contract LicenseDiamond is LicenseRegistry,ILicenseDiamond{
    uint256 public licenseCounter=0;    
    mapping(uint256=>LicenseLib.LicenseIds) public licenses;


    constructor(
        address _accessRestrictionAddress
    ) LicenseRegistry(_accessRestrictionAddress){
    }

    fallback() external payable{
        bytes4 _actionFunc=msg.sig;
        address x;
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
             // execute function call using the facet
            let result := delegatecall(gas(),x , 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
        
    }
    receive() external payable {}

    

    
}