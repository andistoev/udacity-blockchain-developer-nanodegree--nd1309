// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseAirlineAppInsurerController.sol";
import "../shared/OwnableContract.sol";
import "../shared/PayableContract.sol";
import "./BaseSuretyAppContract.sol";

abstract contract AirlineAppInsurerController is BaseAirlineAppInsurerController, BaseSuretyAppContract, OwnableContract, PayableContract {

    /**
    * API
    */

    function registerTheFirstAirline(address airlineAddress, string memory airlineName) external requireContractOwner {
        require(!registeredAirlines[airlineAddress], "Airline can not be registered twice");

        registeredAirlines[airlineAddress] = true;
        getSuretyDataContract().registerTheFirstFullyQualifiedInsurer(airlineAddress, airlineName);
    }

    function registerAirline(address airlineAddress, string memory airlineName) external {
        require(!registeredAirlines[airlineAddress], "Airline can not be registered twice");

        registeredAirlines[airlineAddress] = true;
        getSuretyDataContract().registerInsurer(msg.sender, airlineAddress, airlineName);
    }

    function approveAirline(address airlineAddress) external requireRegisteredAirline(airlineAddress) {
        getSuretyDataContract().approveInsurer(msg.sender, airlineAddress);
    }

    function payAirlineInsurerFee() external payable requireRegisteredAirline(msg.sender) {
        getSuretyDataContract().payInsurerFee{value : msg.value}(msg.sender);
    }

}
