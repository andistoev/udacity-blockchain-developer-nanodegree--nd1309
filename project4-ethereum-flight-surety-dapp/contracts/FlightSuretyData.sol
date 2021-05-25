// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "./BaseFlightSuretyData.sol";
import "./data/OwnableContract.sol";
import "./data/OperationalContract.sol";
import "./data/Insurer.sol";
import "./data/Insuree.sol";
import "./data/CallableContract.sol";

contract FlightSuretyData is BaseFlightSuretyData, OwnableContract, OperationalContract, CallableContract, Insurer, Insuree {

    constructor() OwnableContract(){
    }

    /**
     * @dev Initial funding for the insurance. Unless there are too many delayed flights
     *      resulting in insurance payouts, the contract should be self-sustaining
     *
     */
    function fund() public payable {
    }

    /**
    * @dev Fallback function for funding smart contract.
    *
    */
    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }


}

