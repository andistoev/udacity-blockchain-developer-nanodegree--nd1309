// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./shared/OwnableContract.sol";

import "./app/AppContract.sol";
import "./app/OracleController.sol";
import "./app/AirlineAppInsurerController.sol";
import "./app/FlightAppInsuranceController.sol";

contract FlightSuretyApp is OwnableContract, AppContract, AirlineAppInsurerController, FlightAppInsuranceController, OracleController {

    constructor(address flightSuretyDataAddress) OwnableContract() AppContract(flightSuretyDataAddress) {
    }

}   
