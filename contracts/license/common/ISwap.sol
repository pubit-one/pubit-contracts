// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;


interface ISwap{
    error InvalidAccessRestriction(address access);
    error InvalidFactoryAddress(address factory);
    error InvalidFee(uint24 fee);
}