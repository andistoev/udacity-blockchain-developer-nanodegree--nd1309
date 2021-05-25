// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseInsuree.sol";

abstract contract Insuree is BaseInsuree {

    function buyInsurance() external payable override {

    }

    function withdrawInsuranceCredit() external pure override {
    }
}

