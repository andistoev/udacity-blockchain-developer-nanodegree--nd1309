// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./shared/OwnableContract.sol";

import "./data/DataOperationalContract.sol";
import "./data/DataContract.sol";
import "./data/DataInsurerController.sol";
import "./data/DataInsuranceController.sol";

import "./shared/BaseFlightSuretyData.sol";

contract FlightSuretyData is OwnableContract, DataOperationalContract, DataContract, DataInsurerController, DataInsuranceController, BaseFlightSuretyData {

    constructor() OwnableContract(){
    }

    /**
     * @dev Initial funding for the insurance. Unless there are too many delayed flights
     *      resulting in insurance payouts, the contract should be self-sustaining
     *
     */

    fallback() external payable {
    }

    receive() external payable {
    }


}

