// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseInsuree {
    function buyInsurance() external payable;

    function withdrawInsuranceCredit() external pure;
}
