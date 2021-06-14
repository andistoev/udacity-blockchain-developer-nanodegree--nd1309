// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

abstract contract BaseOracleListenerHandler {
    function processFlightStatusInfoUpdated(address airlineAddress, string memory flightNumber, uint256 departureTime, uint8 statusCode) internal virtual;
}
