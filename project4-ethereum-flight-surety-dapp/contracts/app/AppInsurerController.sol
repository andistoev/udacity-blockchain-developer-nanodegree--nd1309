// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "../shared/BaseInsurerController.sol";
import "./AppContract.sol";

abstract contract AppInsurerController is PayableContract, BaseInsurerController, AppContract {

    /**
    * API
    */

    function registerAirline() external pure returns (bool success, uint256 votes){
        return (success, 0);
    }

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
