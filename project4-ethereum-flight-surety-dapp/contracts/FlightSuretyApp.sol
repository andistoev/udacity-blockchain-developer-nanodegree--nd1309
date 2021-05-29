// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./shared/OwnableContract.sol";

import "./app/AppContract.sol";
import "./app/OracleController.sol";
import "./app/AppInsurerController.sol";
import "./app/AppInsuranceController.sol";
import "./app/FlightInsuranceController.sol";


contract FlightSuretyApp is OwnableContract, AppContract, OracleController, AppInsurerController, AppInsuranceController, FlightInsuranceController {

    constructor(address flightSuretyDataAddress) OwnableContract() AppContract(flightSuretyDataAddress) {
    }

}   
