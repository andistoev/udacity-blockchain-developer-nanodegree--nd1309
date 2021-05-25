// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "./BaseInsuree.sol";

abstract contract Insuree is BaseInsuree {

    function buyInsurance() external payable override {

    }

    function withdrawInsuranceCredit() external pure override {
    }
}

