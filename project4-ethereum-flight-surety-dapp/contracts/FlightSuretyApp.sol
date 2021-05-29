// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./app/AppContract.sol";
import "./app/OracleController.sol";
import "./app/FlightInsuranceController.sol";

contract FlightSuretyApp is AppContract, OracleController, FlightInsuranceController {

    constructor(address flightSuretyDataAddress) OwnableContract() AppContract(flightSuretyDataAddress) {
    }

}   
