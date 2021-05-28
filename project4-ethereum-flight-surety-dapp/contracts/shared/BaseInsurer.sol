// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseInsurer {
    function registerInsurer(address insurerAddress, string memory insurerName) external;

    function approveInsurer(address insurerAddress) external;

    function payInsurerFee() external payable;
}
