// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "../shared/BaseInsuranceController.sol";
import "./AppContract.sol";

abstract contract AppInsuranceController is PayableContract, BaseInsuranceController, AppContract {

    /**
    * API
    */

    function buyInsurance(string calldata insuredObjectId) external payable override {
        dataContract.buyInsurance(insuredObjectId);
    }

    function withdrawInsuranceCredit(string memory insuredObjectId) external payable override {
        dataContract.withdrawInsuranceCredit(insuredObjectId);
    }

}
