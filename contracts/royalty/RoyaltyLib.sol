// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

library RoyaltyLib {
    struct Share {
        address holder;
        uint96 share;
    }
    struct Royalty{
        uint16 totalShare;
        address recipient;
    }

    error InvalidToken(address tokenAddress);
    error NotShareHolder(address caller);
    error InvalidWithdrawAmount(uint amount);
    error InvalidAddress(address addr);
    error InsufficientBalance();
    error TransferFailed();
    error InvalidShare(uint96 share);


    function processShares(Share[] memory _shares)
    internal
    pure
    returns (uint256)
    {
        uint256 sumShares=0;
        for (uint256 i = 0; i < _shares.length; i++) {
            if(_shares[i].holder==address(0x0)){
                revert RoyaltyLib.InvalidAddress(_shares[i].holder);
            }
            if(_shares[i].share==0){
                revert RoyaltyLib.InvalidShare(_shares[i].share);
            }
            sumShares+=_shares[i].share;
        }
        return sumShares;
    }
    
}
