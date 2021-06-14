// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./base/BaseAppInsurerController.sol";
import "./base/BaseAppContract.sol";
import "../shared/OwnableContract.sol";
import "../shared/PayableContract.sol";

abstract contract AppInsurerController is BaseAppInsurerController, BaseAppContract, OwnableContract, PayableContract {

    struct Airline {
        bool isRegistered;
        string name;
    }

    // key => address
    mapping(address => Airline) internal airlines;

    /**
    * API
    */

    function registerTheFirstAirline(address airlineAddress, string memory airlineName) external requireContractOwner {
        require(!airlines[airlineAddress].isRegistered, "Airline cannot be registered twice");

        airlines[airlineAddress].name = airlineName;
        airlines[airlineAddress].isRegistered = true;

        suretyDataContract.registerTheFirstInsurer(airlineAddress);
    }

    function registerAirline(address airlineAddress, string memory airlineName) external requireIsOperational {
        airlines[airlineAddress].name = airlineName;
        airlines[airlineAddress].isRegistered = true;

        suretyDataContract.registerInsurer(msg.sender, airlineAddress);
    }

    function payAirlineInsurerFee() external payable requireIsOperational {
        requireRegisteredAirline(msg.sender, "Only registered airline can pay insurer fee");
        suretyDataContract.payInsurerFee{value : msg.value}(msg.sender);
    }

    /**
    * Modifiers and private methods
    */

    function requireRegisteredAirline(address airlineAddress, string memory errorMsg) view internal override {
        require(airlines[airlineAddress].isRegistered, errorMsg);
    }

}
