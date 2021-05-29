// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./app/AppContract.sol";
import "./app/OracleController.sol";
import "./app/FlightInsuranceController.sol";
import "./app/AppInsuranceController.sol";
import "./app/AppInsurerController.sol";

contract FlightSuretyApp is AppContract, OracleController, AppInsuranceController, AppInsurerController, FlightInsuranceController {

    constructor(address flightSuretyDataAddress) OwnableContract() AppContract(flightSuretyDataAddress) {
    }

}   
