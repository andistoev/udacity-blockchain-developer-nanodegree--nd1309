// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseOperationalContract.sol";
import "../shared/OwnableContract.sol";

abstract contract OperationalContract is BaseOperationalContract, OwnableContract {

    bool private operational = true;

    function isContractOperational() external view override returns (bool){
        return operational;
    }

    function pauseContract() external override requireContractOwner {
        operational = false;
    }

    function resumeContract() external override requireContractOwner {
        operational = true;
    }

    modifier requireIsOperational(){
        require(operational, "Contract is currently not operational");
        _;
    }
}

