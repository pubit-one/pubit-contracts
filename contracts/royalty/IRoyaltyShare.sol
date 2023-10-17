// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;


interface IRoyaltyShare {
    event Erc20Withdrawn(
        address tokenAddress,
        uint256 amount,
        address recipient
    );

    event BaseWithdrawn(uint256 amount, address recipient);

    event Received(address, uint256);

    function withdrawBalance(uint256 _amount, address tokenAddress) external;

    function withdrawBase(uint256 _amount) external;

    function creator() external view returns (address);

    function sumShares() external view returns (uint256);

    function baseWithdraws() external view returns (uint256);

    function holderBaseWithdraws(address _recipient)
        external
        view
        returns (uint256);

    function tokenWithdraws(address _recipient) external view returns (uint256);

    function holderShares(address _recipient) external view returns (uint256);

    function holderTokenWithdraws(address _recipient, address _tokenAddress)
        external
        view
        returns (uint256);
}
