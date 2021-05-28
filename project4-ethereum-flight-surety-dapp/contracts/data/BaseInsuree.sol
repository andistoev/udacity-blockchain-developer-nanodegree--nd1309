// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseInsuree {
    function buyInsurance(string calldata insuredObjectId) external payable;

    function withdrawInsuranceCredit(string calldata insuredObjectId) external payable;
}
