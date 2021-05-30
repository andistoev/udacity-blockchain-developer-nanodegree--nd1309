// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseAirlineAppInsurerController.sol";
import "../shared/OwnableContract.sol";
import "../shared/PayableContract.sol";
import "./SuretyAppContract.sol";

abstract contract AirlineAppInsurerController is BaseAirlineAppInsurerController, OwnableContract, PayableContract, SuretyAppContract {

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

    function approveAirline(address airlineAddress) external requireRegisteredAirline(airlineAddress) {
        suretyDataContract.approveInsurer(airlineAddress);
    }

    function payAirlineInsurerFee() external payable requireRegisteredAirline(msg.sender) {
        suretyDataContract.payInsurerFee();
    }

}
