// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseSuretyData.sol";
import "../shared/PayableContract.sol";

abstract contract AppContract is PayableContract {

    BaseSuretyData internal suretyDataContract;

    /**
    * API
    */

    constructor(address suretyDataContractAddress) {
        suretyDataContract = BaseSuretyData(suretyDataContractAddress);
    }

    receive() external payable {
        payTo(address(suretyDataContract), msg.value, "Can not fund suretyDataContract");
    }

    /**
    * Modifiers and private methods
    */


}

