// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./base/BaseAppInsurerController.sol";
import "./base/BaseAppContract.sol";
import "../shared/OwnableContract.sol";
import "../shared/PayableContract.sol";

abstract contract AppInsurerController is BaseAppInsurerController, BaseAppContract, OwnableContract, PayableContract {

    /**
    * API
    */

    function registerTheFirstAirline(address airlineAddress, string memory airlineName) external requireContractOwner {
        require(!registeredAirlines[airlineAddress], "Airline cannot be registered twice");

        registeredAirlines[airlineAddress] = true;
        suretyDataContract.registerTheFirstInsurer(airlineAddress, airlineName);
    }

    function registerAirline(address airlineAddress, string memory airlineName) external {
        require(!registeredAirlines[airlineAddress], "Airline cannot be registered twice");

        registeredAirlines[airlineAddress] = true;
        suretyDataContract.registerInsurer(msg.sender, airlineAddress, airlineName);
    }

    function approveAirline(address airlineAddress) external requireRegisteredAirline(airlineAddress) {
        suretyDataContract.approveInsurer(msg.sender, airlineAddress);
    }

    function payAirlineInsurerFee() external payable requireRegisteredAirline(msg.sender) {
        suretyDataContract.payInsurerFee{value : msg.value}(msg.sender);
    }

}
