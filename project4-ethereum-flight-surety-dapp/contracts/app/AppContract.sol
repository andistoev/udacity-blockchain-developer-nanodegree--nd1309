// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseSuretyData.sol";

abstract contract AppContract {

    BaseSuretyData internal suretyDataContract;

    /**
    * API
    */

    constructor(address suretyDataContractAddress) {
        suretyDataContract = BaseSuretyData(suretyDataContractAddress);
    }

    /**
    * Modifiers and private methods
    */


}

