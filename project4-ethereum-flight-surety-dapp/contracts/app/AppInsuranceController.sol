// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./base/BaseAppContract.sol";
import "./base/BaseOracleListenerHandler.sol";
import "./base/BaseAppInsurerController.sol";
import "../shared/PayableContract.sol";
import "./base/BaseAppInsuranceController.sol";

abstract contract AppInsuranceController is BaseAppInsuranceController, BaseAppInsurerController, BaseOracleListenerHandler, BaseAppContract, PayableContract {

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
        bool isClosed;

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

    function registerFlight(string memory flightNumber, uint256 departureTime, string memory origin, string memory destination) external requireIsOperational {
        address airlineAddress = msg.sender;
        requireRegisteredAirline(airlineAddress, "Only an registered airline can register flights");

        bytes32 insuredObjectKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        require(!flights[insuredObjectKey].isRegistered, "The same flight cannot be registered twice");

        flights[insuredObjectKey] = Flight(
            true,
            false,
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
        bytes32 flightKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        requireRegisteredFlight(flightKey);
        requireNotClosedFlight(flightKey);

        suretyDataContract.buyInsurance{value : msg.value}(msg.sender, flightKey);
    }

    function withdrawFlightInsuranceCredit(address airlineAddress, string memory flightNumber, uint256 departureTime) external requireIsOperational {
        bytes32 flightKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        requireRegisteredFlight(flightKey);

        suretyDataContract.withdrawInsuranceCredit(msg.sender, flightKey);
    }

    /**
    * Modifiers and private methods
    */

    function processFlightStatusInfoUpdated(address airlineAddress, string memory flightNumber, uint256 departureTime, uint8 statusCode) internal override {
        bytes32 flightKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        requireRegisteredFlight(flightKey);

        if (statusCode == STATUS_CODE_LATE_AIRLINE) {
            suretyDataContract.approveAllInsuranceCreditWithdraws(flightKey);
        }
        else {
            suretyDataContract.closeAllInsurances(flightKey);
        }
    }

    function getFlightKey(address airlineAddress, string memory flightNumber, uint256 departureTime) pure internal override returns (bytes32){
        return keccak256(abi.encodePacked(airlineAddress, flightNumber, departureTime));
    }

    function requireRegisteredFlight(bytes32 flightKey) view internal override {
        require(flights[flightKey].isRegistered, "The flight has not been registered");
    }

    function requireNotClosedFlight(bytes32 flightKey) view internal override {
        require(!flights[flightKey].isClosed, "The flight has been already closed");
    }

    function closeFlight(bytes32 flightKey) internal override {
        flights[flightKey].isClosed = true;
    }

}
