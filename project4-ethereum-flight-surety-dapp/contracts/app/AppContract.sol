// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseFlightSuretyData.sol";

abstract contract AppContract {

    BaseFlightSuretyData private flightSuretyData;

    /**
    * API
    */

    constructor(address flightSuretyDataAddress) {
        flightSuretyData = BaseFlightSuretyData(flightSuretyDataAddress);
    }

    /**
    * Modifiers and private methods
    */


}

