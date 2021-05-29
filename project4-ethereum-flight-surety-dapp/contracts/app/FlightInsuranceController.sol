// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/OwnableContract.sol";

abstract contract FlightInsuranceController is OwnableContract {

    // Flight status codees
    uint8 private constant STATUS_CODE_UNKNOWN = 0;
    uint8 private constant STATUS_CODE_ON_TIME = 10;
    uint8 private constant STATUS_CODE_LATE_AIRLINE = 20;
    uint8 private constant STATUS_CODE_LATE_WEATHER = 30;
    uint8 private constant STATUS_CODE_LATE_TECHNICAL = 40;
    uint8 private constant STATUS_CODE_LATE_OTHER = 50;

    struct Flight {
        bool isRegistered;
        uint8 statusCode;
        uint256 updatedTimestamp;
        address airline;
    }

    mapping(bytes32 => Flight) private flights;

    /**
    * API
    */

    /**
     * @dev Add an airline to the registration queue
     *
     */
    function registerAirline() external pure returns (bool success, uint256 votes)
    {
        return (success, 0);
    }

    /**
     * @dev Register a future flight for insuring.
     *
     */
    function registerFlight() external pure {

    }

    /**
    * Modifiers and private methods
    */


}
