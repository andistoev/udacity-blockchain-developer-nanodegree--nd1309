// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseFlightSuretyData.sol";

abstract contract AppContract {

    BaseFlightSuretyData internal dataContract;

    /**
    * API
    */

    constructor(address dataContractAddress) {
        dataContract = BaseFlightSuretyData(dataContractAddress);
    }

    /**
    * Modifiers and private methods
    */


}

