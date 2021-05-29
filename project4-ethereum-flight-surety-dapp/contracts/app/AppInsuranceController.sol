// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "./AppContract.sol";

abstract contract AppInsuranceController is PayableContract, AppContract {

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


    function registerFlight(address airline, string memory flight, uint256 timestamp) external {
        bytes32 insuredObjectKey = getFlightKey(airline, flight, timestamp);
        dataContract.registerInsuredObject(insuredObjectKey);
    }

    function buyFlightInsurance(address airline, string memory flight, uint256 timestamp) external payable {
        bytes32 insuredObjectKey = getFlightKey(airline, flight, timestamp);
        dataContract.buyInsurance(insuredObjectKey);
    }

    function withdrawFlightInsuranceCredit(address airline, string memory flight, uint256 timestamp) external payable {
        bytes32 insuredObjectKey = getFlightKey(airline, flight, timestamp);
        dataContract.withdrawInsuranceCredit(insuredObjectKey);
    }

    /**
    * Modifiers and private methods
    */

    function processFlightStatusInfoUpdated(address airline, string memory flight, uint256 timestamp, uint8 statusCode) internal {
        bytes32 insuredObjectId = getFlightKey(airline, flight, timestamp);

        if (statusCode == STATUS_CODE_LATE_AIRLINE) {
            dataContract.approveAllInsuranceCreditWithdraws(insuredObjectId);
        }
        else {
            dataContract.closeAllInsurances(insuredObjectId);
        }
    }

    function getFlightKey(address airline, string memory flight, uint256 timestamp) pure private returns (bytes32){
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

}
