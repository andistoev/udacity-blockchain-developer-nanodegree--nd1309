// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./base/BaseAppContract.sol";
import "../shared/BaseSuretyData.sol";
import "../shared/PayableContract.sol";

abstract contract AppContract is BaseAppContract, PayableContract {

    /**
    * API
    */

    constructor(address suretyDataContractAddress) {
        suretyDataContract = BaseSuretyData(suretyDataContractAddress);
    }

    receive() external payable {
        payTo(address(suretyDataContract), msg.value, "Cannot fund suretyDataContract");
    }

}

