// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "./IAccessRestriction.sol";

/** @title AccessRestriction contract */

contract AccessRestriction is
    AccessControlUpgradeable,
    IAccessRestriction
{
    bytes32 public constant Project_CONTRACT_ROLE =
        keccak256("Project_CONTRACT_ROLE");
    bytes32 public constant DATA_MANAGER_ROLE = keccak256("DATA_MANAGER_ROLE");

    /** NOTE {isAccessRestriction} set inside the initialize to {true} */
    bool public override isAccessRestriction;

    /** NOTE modifier to check msg.sender has admin role */
    modifier onlyAdmin() {
        if(!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)){
            revert NotAdmin(msg.sender);
        }
        _;
    }

    /**
     * @dev initialize accessRestriction contract and set true for {isAccessRestriction}
     * @param _deployer address of the deployer that DEFAULT_ADMIN_ROLE set to it
     */
    function initialize(address _deployer) external override initializer {
        AccessControlUpgradeable.__AccessControl_init();
        // PausableUpgradeable.__Pausable_init();

        isAccessRestriction = true;

        if (!hasRole(DEFAULT_ADMIN_ROLE, _deployer)) {
            _grantRole(DEFAULT_ADMIN_ROLE, _deployer);
        }
    }

    /**
     * @dev check if given address is admin
     * @param _address input address
     */
    function ifAdmin(address _address) external view override {
        if(!isAdmin(_address)){
            revert NotAdmin(_address);
        }
    }

    /**
     * @dev check if given address is Project contract
     * @param _address input address
     */
    function ifProjectContract(address _address) external view override {
        if(!isProjectContract(_address)){
            revert NotProjectContract(_address);
        }
    }

    /**
     * @dev check if given address is data manager
     * @param _address input address
     */
    function ifDataManager(address _address) external view override {
        if(!isDataManager(_address)){
            revert NotDataManager(_address);
        }
    }


    /**
     * @dev check if given address has admin role
     * @param _address input address
     * @return if given address has admin role
     */
    function isAdmin(address _address) public view override returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, _address);
    }

    /**
     * @dev check if given address has Project contract role
     * @param _address input address
     * @return if given address has Project contract role
     */
    function isProjectContract(address _address)
        public
        view
        override
        returns (bool)
    {
        return hasRole(Project_CONTRACT_ROLE, _address);
    }

    /**
     * @dev check if given address has data manager role
     * @param _address input address
     * @return if given address has data manager role
     */
    function isDataManager(address _address)
        public
        view
        override
        returns (bool)
    {
        return hasRole(DATA_MANAGER_ROLE, _address);
    }
}
