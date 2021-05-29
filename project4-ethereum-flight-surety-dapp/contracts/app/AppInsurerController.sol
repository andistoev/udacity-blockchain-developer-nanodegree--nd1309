// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "../shared/BaseInsurerController.sol";
import "./AppContract.sol";

abstract contract AppInsurerController is PayableContract, BaseInsurerController, AppContract {

    /**
    * API
    */

    function registerInsurer(address insurerAddress, string memory insurerName) external override {
        dataContract.registerInsurer(insurerAddress, insurerName);
    }

    function approveInsurer(address insurerAddress) external override {
        dataContract.approveInsurer(insurerAddress);
    }

    function payInsurerFee() external payable override {
        dataContract.payInsurerFee();
    }

}
