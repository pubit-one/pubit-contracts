// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

library RoyaltyLib {
    struct Share {
        address holder;
        uint16 share;
    }
    struct Royalty{
        uint16 totalShare;
        address recipient;
    }

    error InvalidToken(address tokenAddress);
    error NotShareHolder(address caller);
    error InvalidWithdrawAmount(uint amount);
    error InvalidAddress(address addr);
    error Insuffiecen();


    function processShares(Share[] memory _shares)
    internal
    pure
    returns (uint256)
    {
        uint256 sumShares=0;
        for (uint256 i = 0; i < _shares.length; i++) {
            require(_shares[i].holder!=address(0x0),"invalid shareholder address");
            require(_shares[i].share>0,"invalid share");
            sumShares+=_shares[i].share;
        }
        return sumShares;
    }
    
}
