// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseOperationalContract.sol";
import "./BaseSuretyAppContract.sol";
import "../shared/OwnableContract.sol";


abstract contract AppOperationalContract is BaseOperationalContract, BaseSuretyAppContract, OwnableContract {

    /**
    * API
    */

    function isContractOperational() external view override returns (bool){
        return getSuretyDataContract().isContractOperational();
    }

    function pauseContract() external override requireContractOwner {
        getSuretyDataContract().pauseContract();
    }

    function resumeContract() external override requireContractOwner {
        getSuretyDataContract().resumeContract();
    }

    /**
    * Modifiers and private methods
    */

    modifier requireIsOperational() {
        require(getSuretyDataContract().isContractOperational(), "Contract is currently not operational");
        _;
    }
}

