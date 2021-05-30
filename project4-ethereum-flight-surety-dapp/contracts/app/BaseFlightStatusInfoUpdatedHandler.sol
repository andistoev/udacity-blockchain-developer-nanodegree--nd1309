// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract BaseFlightStatusInfoUpdatedHandler {

    function processFlightStatusInfoUpdated(address airline, string memory flightNumber, uint256 departureTime, uint8 statusCode) internal virtual;

}
