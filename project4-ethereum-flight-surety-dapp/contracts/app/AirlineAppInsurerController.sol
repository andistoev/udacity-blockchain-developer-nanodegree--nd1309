// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "./AppContract.sol";

abstract contract AirlineAppInsurerController is PayableContract, AppContract {

    // key => address
    mapping(address => bool) private registeredAirlines;

    /**
    * API
    */

    function registerAirline(address airlineAddress, string memory airlineName) external {
        require(!registeredAirlines[airlineAddress], "Airline can not be registered twice");

        registeredAirlines[airlineAddress] = true;
        dataContract.registerInsurer(airlineAddress, airlineName);
    }

    function approveAirline(address airlineAddress) external requiredRegisteredAirline(airlineAddress) {
        dataContract.approveInsurer(airlineAddress);
    }

    function payAirlineInsurerFee() external payable requiredRegisteredAirline(msg.sender) {
        dataContract.payInsurerFee();
    }

    /**
    * Modifiers and private methods
    */

    modifier requiredRegisteredAirline(address airlineAddress){
        require(registeredAirlines[airlineAddress], "Airline has not been registered");
        _;
    }

}
