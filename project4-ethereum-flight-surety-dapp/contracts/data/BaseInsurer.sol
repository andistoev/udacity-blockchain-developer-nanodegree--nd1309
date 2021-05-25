// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseInsurer {
    function registerInsurer() external pure;

    function payInsurersFee() external payable;
}
