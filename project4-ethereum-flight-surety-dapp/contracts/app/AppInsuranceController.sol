// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./base/BaseAppContract.sol";
import "./base/BaseOracleListenerHandler.sol";
import "./base/BaseAppInsurerController.sol";
import "../shared/PayableContract.sol";

abstract contract AppInsuranceController is BaseOracleListenerHandler, BaseAppInsurerController, BaseAppContract, PayableContract {

    uint internal constant MIN_INSURANCE_PRICE = 1 wei;
    uint internal constant MAX_INSURANCE_PRICE = 1 ether;

    // Flight status codees
    uint8 private constant STATUS_CODE_UNKNOWN = 0;
    uint8 private constant STATUS_CODE_ON_TIME = 10;
    uint8 private constant STATUS_CODE_LATE_AIRLINE = 20;
    uint8 private constant STATUS_CODE_LATE_WEATHER = 30;
    uint8 private constant STATUS_CODE_LATE_TECHNICAL = 40;
    uint8 private constant STATUS_CODE_LATE_OTHER = 50;

    struct Flight {
        bool isRegistered;

        address airlineAddress;
        string flightNumber;
        uint256 departureTime;

        string origin;
        string destination;

        uint8 statusCode;
    }

    // key => keccak256(abi.encodePacked(airlineAddress, flightNumber, departureTime))
    mapping(bytes32 => Flight) private flights;

    /**
    * API
    */

    function registerFlight(address airlineAddress, string memory flightNumber, uint256 departureTime, string memory origin, string memory destination) external requireIsOperational {
        requireRegisteredAirline(airlineAddress);

        bytes32 insuredObjectKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        require(!flights[insuredObjectKey].isRegistered, "The same flight cannot be registered twice");

        flights[insuredObjectKey] = Flight(
            true,
            airlineAddress,
            flightNumber,
            departureTime,
            origin,
            destination,
            STATUS_CODE_UNKNOWN
        );

        suretyDataContract.registerInsuredObject(insuredObjectKey);
    }

    function buyFlightInsurance(address airlineAddress, string memory flightNumber, uint256 departureTime) external payable requireIsOperational {
        bytes32 insuredObjectKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        suretyDataContract.buyInsurance{value : msg.value}(msg.sender, insuredObjectKey);
    }

    function withdrawFlightInsuranceCredit(address airlineAddress, string memory flightNumber, uint256 departureTime) external requireIsOperational {
        bytes32 insuredObjectKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        suretyDataContract.withdrawInsuranceCredit(msg.sender, insuredObjectKey);
    }

    /**
    * Modifiers and private methods
    */

    function processFlightStatusInfoUpdated(address airlineAddress, string memory flightNumber, uint256 departureTime, uint8 statusCode) internal override {
        bytes32 insuredObjectKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        if (statusCode == STATUS_CODE_LATE_AIRLINE) {
            suretyDataContract.approveAllInsuranceCreditWithdraws(insuredObjectKey);
        }
        else {
            suretyDataContract.closeAllInsurances(insuredObjectKey);
        }
    }

    function getFlightKey(address airlineAddress, string memory flightNumber, uint256 departureTime) pure private returns (bytes32){
        return keccak256(abi.encodePacked(airlineAddress, flightNumber, departureTime));
    }

}
