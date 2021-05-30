// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseAirlineAppInsurerController.sol";
import "../shared/OwnableContract.sol";
import "../shared/PayableContract.sol";
import "./AppContract.sol";

abstract contract AirlineAppInsurerController is BaseAirlineAppInsurerController, OwnableContract, PayableContract, AppContract {

    /**
    * API
    */

    function registerTheFirstAirline(address airlineAddress, string memory airlineName) external requireContractOwner {
        require(!registeredAirlines[airlineAddress], "Airline can not be registered twice");

        registeredAirlines[airlineAddress] = true;
        suretyDataContract.registerTheFirstFullyQualifiedInsurer(airlineAddress, airlineName);
    }

    function registerAirline(address airlineAddress, string memory airlineName) external {
        require(!registeredAirlines[airlineAddress], "Airline can not be registered twice");

        registeredAirlines[airlineAddress] = true;
        suretyDataContract.registerInsurer(airlineAddress, airlineName);
    }

    function approveAirline(address airlineAddress) external requiredRegisteredAirline(airlineAddress) {
        suretyDataContract.approveInsurer(airlineAddress);
    }

    function payAirlineInsurerFee() external payable requiredRegisteredAirline(msg.sender) {
        suretyDataContract.payInsurerFee();
    }

}
