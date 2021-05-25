// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseInsurer.sol";

abstract contract Insurer is BaseInsurer {

    function registerInsurer() external pure override {
    }

    function payInsurersFee() external payable override {
    }
}

