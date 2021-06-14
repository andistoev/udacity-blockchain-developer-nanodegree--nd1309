// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "../shared/BaseOperationalContract.sol";
import "../shared/OwnableContract.sol";

abstract contract DataOperationalContract is BaseOperationalContract, OwnableContract {

    bool private operational = true;

    /**
    * API
    */

    function isContractOperational() external view override returns (bool){
        return operational;
    }

    function pauseContract() external override requireContractOwner {
        operational = false;
    }

    function resumeContract() external override requireContractOwner {
        operational = true;
    }

    /**
    * Modifiers and private methods
    */

    modifier requireIsOperational() {
        require(operational, "Contract is currently not operational");
        _;
    }
}

