// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "../shared/BaseInsuranceController.sol";
import "./AppContract.sol";

abstract contract AppInsuranceController is PayableContract, BaseInsuranceController, AppContract {

    // Flight status codees
    uint8 private constant STATUS_CODE_UNKNOWN = 0;
    uint8 private constant STATUS_CODE_ON_TIME = 10;
    uint8 private constant STATUS_CODE_LATE_AIRLINE = 20;
    uint8 private constant STATUS_CODE_LATE_WEATHER = 30;
    uint8 private constant STATUS_CODE_LATE_TECHNICAL = 40;
    uint8 private constant STATUS_CODE_LATE_OTHER = 50;

    struct Flight {
        bool isRegistered;
        uint8 statusCode;
        uint256 updatedTimestamp;
        address airline;
    }

    mapping(bytes32 => Flight) private flights;

    /**
    * API
    */

    function processFlightStatusInfoUpdated(address airline, string memory flight, uint256 timestamp, uint8 statusCode) internal pure {
    }

    function registerAirline() external pure returns (bool success, uint256 votes)
    {
        return (success, 0);
    }

    function registerFlight() external pure {

    }

    function buyInsurance(string calldata insuredObjectId) external payable override {
        dataContract.buyInsurance(insuredObjectId);
    }

    function withdrawInsuranceCredit(string memory insuredObjectId) external payable override {
        dataContract.withdrawInsuranceCredit(insuredObjectId);
    }

}
