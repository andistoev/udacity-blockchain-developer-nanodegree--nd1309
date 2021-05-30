// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "./AppContract.sol";
import "./AirlineAppInsurerController.sol";

abstract contract FlightAppInsuranceController is PayableContract, AppContract, AirlineAppInsurerController {

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

    function registerFlight(address airlineAddress, string memory flightNumber, uint256 departureTime) external requiredRegisteredAirline(airlineAddress) {
        bytes32 insuredObjectKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        require(!flights[insuredObjectKey].isRegistered, "The same flight can not be registered twice");

        flights[insuredObjectKey] = Flight(
            true,
            airlineAddress,
            flightNumber,
            departureTime,
            STATUS_CODE_UNKNOWN
        );

        dataContract.registerInsuredObject(insuredObjectKey);
    }

    function buyFlightInsurance(address airline, string memory flightNumber, uint256 departureTime) external payable {
        bytes32 insuredObjectKey = getFlightKey(airline, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        dataContract.buyInsurance(insuredObjectKey);
    }

    function withdrawFlightInsuranceCredit(address airline, string memory flightNumber, uint256 departureTime) external payable {
        bytes32 insuredObjectKey = getFlightKey(airline, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        dataContract.withdrawInsuranceCredit(insuredObjectKey);
    }

    /**
    * Modifiers and private methods
    */

    function processFlightStatusInfoUpdated(address airline, string memory flightNumber, uint256 departureTime, uint8 statusCode) internal {
        bytes32 insuredObjectKey = getFlightKey(airline, flightNumber, departureTime);
        require(flights[insuredObjectKey].isRegistered, "The flight has not been registered");

        if (statusCode == STATUS_CODE_LATE_AIRLINE) {
            dataContract.approveAllInsuranceCreditWithdraws(insuredObjectKey);
        }
        else {
            dataContract.closeAllInsurances(insuredObjectKey);
        }
    }

    function getFlightKey(address airlineAddress, string memory flightNumber, uint256 departureTime) pure private returns (bytes32){
        return keccak256(abi.encodePacked(airlineAddress, flightNumber, departureTime));
    }

}
