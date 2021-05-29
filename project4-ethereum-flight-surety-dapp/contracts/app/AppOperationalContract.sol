// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseOperationalContract.sol";
import "../shared/OwnableContract.sol";
import "./AppContract.sol";

abstract contract AppOperationalContract is BaseOperationalContract, OwnableContract, AppContract {

    /**
    * API
    */

    function isContractOperational() external view override returns (bool){
        return dataContract.isContractOperational();
    }

    function pauseContract() external override requireContractOwner {
        dataContract.pauseContract();
    }

    function resumeContract() external override requireContractOwner {
        dataContract.resumeContract();
    }

    /**
    * Modifiers and private methods
    */

    modifier requireIsOperational() {
        require(dataContract.isContractOperational(), "Contract is currently not operational");
        _;
    }
}

