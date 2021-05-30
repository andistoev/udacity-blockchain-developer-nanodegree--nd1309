// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract BaseAppInsurerController {

    // key => address
    mapping(address => bool) internal registeredAirlines;

    /**
    * Modifiers and private methods
    */

    modifier requireRegisteredAirline(address airlineAddress){
        require(registeredAirlines[airlineAddress], "Airline has not been registered");
        _;
    }

}
