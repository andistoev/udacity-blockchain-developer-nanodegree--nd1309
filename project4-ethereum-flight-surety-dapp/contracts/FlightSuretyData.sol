// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./shared/OwnableContract.sol";

import "./data/OperationalContractData.sol";
import "./data/CallableContract.sol";

import "./data/InsurerController.sol";
import "./data/InsuranceController.sol";

import "./shared/BaseFlightSuretyData.sol";

contract FlightSuretyData is OwnableContract, OperationalContractData, CallableContract, InsurerController, InsuranceController, BaseFlightSuretyData {

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

