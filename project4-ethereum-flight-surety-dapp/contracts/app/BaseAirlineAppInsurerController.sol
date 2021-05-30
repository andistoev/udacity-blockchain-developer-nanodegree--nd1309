// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "./AppContract.sol";

abstract contract BaseAirlineAppInsurerController {

    // key => address
    mapping(address => bool) internal registeredAirlines;

    /**
    * Modifiers and private methods
    */

    modifier requiredRegisteredAirline(address airlineAddress){
        require(registeredAirlines[airlineAddress], "Airline has not been registered");
        _;
    }

}
