// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseInsuranceManager {
    function buyInsurance(string calldata insuredObjectId) external payable;

    function withdrawInsuranceCredit(string calldata insuredObjectId) external payable;
}
