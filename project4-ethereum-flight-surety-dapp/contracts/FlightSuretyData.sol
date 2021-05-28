// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./shared/OwnableContract.sol";

import "./data/OperationalContract.sol";
import "./data/CallableContract.sol";

import "./data/InsurerManager.sol";
import "./data/InsuranceManager.sol";

import "./shared/BaseFlightSuretyData.sol";

contract FlightSuretyData is OwnableContract, OperationalContract, CallableContract, InsurerManager, InsuranceManager, BaseFlightSuretyData {

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

