// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IRoyaltyShare.sol";
import "./RoyaltyLib.sol";

contract RoyaltyShare is IRoyaltyShare {
    address public override creator;
    uint256 public override sumShares;
    uint256 public override baseWithdraws;

    mapping (address=>bool) public validTokens;

    mapping(address => uint256) public override holderBaseWithdraws;

    /** NOTE mapping of erc20 token to total withdraws from it */
    mapping(address => uint256) public override tokenWithdraws;

    /** NOTE mapping of holder address to holder share */
    mapping(address => uint256) public override holderShares;

    /** NOTE mapping of holder address to token address to withdrawed amount */
    mapping(address => mapping(address => uint256))
        public
        override holderTokenWithdraws;

    constructor(
        address _creator,
        uint256 _sumShares,
        RoyaltyLib.Share[] memory _shares
    ) {
        creator = _creator;

        sumShares = _sumShares;

        for (uint256 i = 0; i < _shares.length; i++) {
            holderShares[_shares[i].holder] = uint256(_shares[i].share);
        }
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
    function updateValidTokens(address _tokenAddress, bool _isValid) external{
        if( holderShares[msg.sender]==0){
            revert RoyaltyLib.NotShareHolder(msg.sender);
        }
        validTokens[_tokenAddress]=_isValid;
    }

    function withdrawBalance(uint256 _amount, address tokenAddress)
        external
        override
    {
        if(_amount==0){
            revert RoyaltyLib.InvalidWithdrawAmount(_amount);
        }
        uint256 share = holderShares[msg.sender];
        if(share==0){
            revert RoyaltyLib.NotShareHolder(msg.sender);
        }
        if(!validTokens[_tokenAddress]){
            revert RoyaltyLib.InvalidToken(_tokenAddress);
        }
        IERC20 token = IERC20(tokenAddress);
        uint256 holderWithdraw = holderTokenWithdraws[msg.sender][tokenAddress];
        uint256 availableBalance = ((token.balanceOf(address(this)) +
            tokenWithdraws[tokenAddress]) * share) / sumShares;
        if(availableBalance < holderWithdraw+_amount){
            revert RoyaltyLib.InsufficientBalance();
        }
        holderTokenWithdraws[msg.sender][tokenAddress] += _amount;
        tokenWithdraws[tokenAddress] += _amount;
        bool success = token.transfer(msg.sender, _amount);
        if (!success){
            revert RoyaltyLib.TransferFailed();
        }
        emit Erc20Withdrawn(tokenAddress, _amount, msg.sender);
    }

    function withdrawBase(uint256 _amount) external override {
        if(_amount==0){
            revert RoyaltyLib.InvalidWithdrawAmount(_amount);
        }
        uint256 share = holderShares[msg.sender];
        if(share==0){
            revert RoyaltyLib.NotShareHolder(msg.sender);
        }
        uint256 holderWithdraw = holderBaseWithdraws[msg.sender];

        uint256 availableBalance = ((address(this).balance + baseWithdraws) *
            share) / sumShares;

        if(availableBalance < holderWithdraw+_amount){
            revert RoyaltyLib.InsufficientBalance();
        }

        holderBaseWithdraws[msg.sender] += _amount;

        baseWithdraws += _amount;

        payable(msg.sender).transfer(_amount);

        emit BaseWithdrawn(_amount, msg.sender);
    }
}