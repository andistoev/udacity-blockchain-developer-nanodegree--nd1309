// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./shared/OwnableContract.sol";

import "./app/AppContract.sol";
import "./app/OracleController.sol";
import "./app/AppInsurerController.sol";
import "./app/AppInsuranceController.sol";

contract FlightSuretyApp is OwnableContract, AppContract, AppInsurerController, AppInsuranceController, OracleController {

    constructor(address flightSuretyDataAddress) OwnableContract() AppContract(flightSuretyDataAddress) {
    }
}   
