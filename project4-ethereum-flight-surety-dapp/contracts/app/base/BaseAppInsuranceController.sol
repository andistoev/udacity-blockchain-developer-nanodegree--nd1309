// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

abstract contract BaseAppInsuranceController {
    function getFlightKey(address airlineAddress, string memory flightNumber, uint256 departureTime) pure internal virtual returns (bytes32);

    function requireRegisteredFlight(bytes32 flightKey) view internal virtual;

    function requireNotClosedFlight(bytes32 flightKey) view internal virtual;

    function closeFlight(bytes32 flightKey) internal virtual;
}
