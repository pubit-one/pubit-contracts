// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.6;

import "./IERC2981.sol";
import "./IERC165.sol";

interface IRoyalty is IERC165, IERC2981 {

    /**
    * @dev emitted when admin updated to maimum value
    * @param maxRoyalty value of royalty
    */
    event MaxRoyaltyUpdated(uint16 maxRoyalty);

    /**
    * @dev external function to initialize the contract
    * @param _accessRestrictionAddress access contract address
    * @param _marketplaceAddress access contract address set
    */ 
    function initialize(
        address _accessRestrictionAddress,
        address _marketplaceAddress
    ) external;


    /**
    * @dev emitted when admin updated to maimum value
    * @param maxRoyalty value of royalty
    */
    function maxRoyalty() external view returns (uint16);

    /**
    * @dev emitted when admin updated to maimum value
    * @param _maxRoyalty value of royalty between 1 to 10000
    */
    function setMaxRoyalty(uint16 _maxRoyalty) external ;
    
}

