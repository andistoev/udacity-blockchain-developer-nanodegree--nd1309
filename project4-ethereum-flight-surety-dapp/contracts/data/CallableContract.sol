// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseCallableContract.sol";
import "../shared/OwnableContract.sol";

abstract contract CallableContract is BaseCallableContract, OwnableContract {

    mapping(address => bool) private authorizedContracts;

    function authorizeContractCaller(address dataContract) external override requireContractOwner {
        authorizedContracts[dataContract] = true;
    }

    function deauthorizeContractCaller(address dataContract) external override requireContractOwner {
        delete authorizedContracts[dataContract];
    }

    modifier requiredAuthorizedCaller() {
        require(authorizedContracts[msg.sender], "Caller is not authorized");
        _;
    }
}

