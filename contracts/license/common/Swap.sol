// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

import "./ISwap.sol";
import "../../access/IAccessRestriction.sol";
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol';
contract Swap is ISwap{
    IAccessRestriction public accessRestriction;
    address public swapFactory;
    address public daiToken;
    uint24 public fee;
    mapping (address=>bool) validTokens;


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
            revert InvalidAccessRestriction(_accessRestrictionAddress);
        }
        accessRestriction = candidateContract;
    }
    function addTokens(address[] memory _tokens) external onlyAdmin() {
        uint size;
        address _addr;
        for(uint i = 0; i <_tokens.length; i++){
            _addr=_tokens[i];
            assembly {
                size := extcodesize(_addr)
            }
            if (size != 0) {
                validTokens[_tokens[i]] =true;
            }
        }
    }
    function removeTokens(address[] memory _tokens) external onlyAdmin() {
        for(uint i = 0; i <_tokens.length; i++){
            validTokens[_tokens[i]] =false; 
        }
    }
    function setFactoryAddress(address _factory) external onlyAdmin() {
        uint size;
        assembly {
            size := extcodesize(_factory)
        }
        if (size == 0) {
            revert InvalidFactoryAddress(_factory);
        }
        factoryAddress = _factory;
    }
    function setDaiToken(address _dai) external onlyAdmin() {
        uint size;
        assembly {
            size := extcodesize(_dai)
        }
        if (size == 0) {
            revert InvalidDaiToken(_dai);
        }
        daiToken = _dai;
    }
    function setFee(uint24 _fee) external onlyAdmin() {
        if (_fee>500 || fee<300) {
            revert InvalidFee(_fee);
        }
        fee = _fee;
    }
    function exactOutputSwap(address _fromToken,uint _DAI)external returns(uint) {
        bytes32 constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
        
        address pool= address(
            uint256(
                keccak256(
                    abi.encodePacked(
                        hex'ff',
                        swapFactory,
                        keccak256(abi.encode(_fromToken, daiToken, fee)),
                        POOL_INIT_CODE_HASH
                    )
                )
            )
        );
        TransferHelper.safeApprove(_fromToken, address(swapRouter), amountInMaximum);


    }

    

}