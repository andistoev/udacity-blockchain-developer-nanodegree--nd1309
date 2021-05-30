// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./base/BaseAppContract.sol";
import "../shared/OwnableContract.sol";

abstract contract AppOperationalContract is BaseAppContract, OwnableContract {

    /**
    * Modifiers and private methods
    */

    modifier requireIsOperational() {
        require(getSuretyDataContract().isContractOperational(), "Contract is currently not operational");
        _;
    }
}

