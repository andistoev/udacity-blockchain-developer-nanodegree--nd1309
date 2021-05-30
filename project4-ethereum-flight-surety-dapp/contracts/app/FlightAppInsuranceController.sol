// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseSuretyAppContract.sol";
import "./BaseFlightStatusInfoUpdatedHandler.sol";
import "./BaseAirlineAppInsurerController.sol";
import "../shared/PayableContract.sol";

abstract contract FlightAppInsuranceController is BaseFlightStatusInfoUpdatedHandler, BaseAirlineAppInsurerController, BaseSuretyAppContract, PayableContract {

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

        uint8 statusCode;
    }

    // key => keccak256(abi.encodePacked(airlineAddress, flightNumber, departureTime))
    mapping(bytes32 => Flight) private flights;

    /**
    * API
    */

    function registerFlight(address airlineAddress, string memory flightNumber, uint256 departureTime) external requireRegisteredAirline(airlineAddress) {
        bytes32 insuredObjectKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        require(!flights[insuredObjectKey].isRegistered, "The same flight can not be registered twice");

        flights[insuredObjectKey] = Flight(
            true,
            airlineAddress,
            flightNumber,
            departureTime,
            STATUS_CODE_UNKNOWN
        );

        getSuretyDataContract().registerInsuredObject(insuredObjectKey);
    }

    function buyFlightInsurance(address airline, string memory flightNumber, uint256 departureTime) external payable {
        bytes32 insuredObjectKey = getFlightKey(airline, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        getSuretyDataContract().buyInsurance(insuredObjectKey);
    }

    function withdrawFlightInsuranceCredit(address airline, string memory flightNumber, uint256 departureTime) external payable {
        bytes32 insuredObjectKey = getFlightKey(airline, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        getSuretyDataContract().withdrawInsuranceCredit(insuredObjectKey);
    }

    /**
    * Modifiers and private methods
    */

    function processFlightStatusInfoUpdated(address airline, string memory flightNumber, uint256 departureTime, uint8 statusCode) internal override {
        bytes32 insuredObjectKey = getFlightKey(airline, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        if (statusCode == STATUS_CODE_LATE_AIRLINE) {
            getSuretyDataContract().approveAllInsuranceCreditWithdraws(insuredObjectKey);
        }
        else {
            getSuretyDataContract().closeAllInsurances(insuredObjectKey);
        }
    }

    function getFlightKey(address airlineAddress, string memory flightNumber, uint256 departureTime) pure private returns (bytes32){
        return keccak256(abi.encodePacked(airlineAddress, flightNumber, departureTime));
    }

}
