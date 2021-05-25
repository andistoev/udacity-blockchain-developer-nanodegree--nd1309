// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseCallableContract.sol";
import "./OwnableContract.sol";

abstract contract CallableContract is BaseCallableContract, OwnableContract {

    mapping(address => bool) private authorizedContracts;

    function enableContractCaller(address dataContract) external override requireContractOwner {
        authorizedContracts[dataContract] = true;
    }

    function disableContractCaller(address dataContract) external override requireContractOwner {
        delete authorizedContracts[dataContract];
    }

    modifier requiredAuthorizedCaller(){
        require(authorizedContracts[msg.sender], "Caller is not authorized");
        _;
    }
}

