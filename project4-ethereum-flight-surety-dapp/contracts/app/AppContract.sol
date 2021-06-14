// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

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

    function isContractOperational() external view returns (bool){
        return suretyDataContract.isContractOperational();
    }

    receive() external payable {
        payTo(address(suretyDataContract), msg.value, "Cannot fund suretyDataContract");
    }

}

