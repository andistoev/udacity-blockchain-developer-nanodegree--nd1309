// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

abstract contract BaseAppInsurerController {
    function requireRegisteredAirline(address airlineAddress, string memory errorMsg) view internal virtual;
}
