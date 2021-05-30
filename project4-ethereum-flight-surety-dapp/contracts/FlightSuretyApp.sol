// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./shared/OwnableContract.sol";

import "./app/SuretyAppContract.sol";
import "./app/OracleController.sol";
import "./app/AirlineAppInsurerController.sol";
import "./app/FlightAppInsuranceController.sol";

contract FlightSuretyApp is OwnableContract, SuretyAppContract, AirlineAppInsurerController, FlightAppInsuranceController, OracleController {

    constructor(address flightSuretyDataAddress) OwnableContract() SuretyAppContract(flightSuretyDataAddress) {
    }
}   
