// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseInsuranceController {
    function buyInsurance(bytes32 insuredObjectKey) external payable;

    function closeAllInsurances(bytes32 insuredObjectKey) external;

    function approveAllInsuranceCreditWithdraws(bytes32 insuredObjectKey) external;

    function withdrawInsuranceCredit(bytes32 insuredObjectKey) external payable;
}
