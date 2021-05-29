// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./app/AppContract.sol";
import "./app/OracleController.sol";
import "./app/FlightInsuranceController.sol";

contract FlightSuretyApp is AppContract, OracleController, FlightInsuranceController {

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */

    modifier requireIsOperational(){
        // Modify to call data contract's status
        require(true, "Contract is currently not operational");
        _;
        // All modifiers require an "_" which indicates where the function body will be added
    }

    constructor(address flightSuretyDataAddress) OwnableContract() AppContract(flightSuretyDataAddress) {
    }


    function isOperational() public pure returns (bool){
        return true;
        // Modify to call data contract's status
    }

}   
