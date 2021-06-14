// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./shared/OwnableContract.sol";

import "./data/DataOperationalContract.sol";
import "./data/DataContract.sol";
import "./data/DataInsurerController.sol";
import "./data/DataInsuranceController.sol";

import "./shared/BaseSuretyData.sol";

contract FlightSuretyData is OwnableContract, DataOperationalContract, DataContract, DataInsurerController, DataInsuranceController, BaseSuretyData {

    constructor() OwnableContract(){
    }

}

