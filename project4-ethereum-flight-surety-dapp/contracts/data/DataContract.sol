// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseDataContract.sol";
import "../shared/OwnableContract.sol";

abstract contract DataContract is BaseDataContract, OwnableContract {

    mapping(address => bool) private authorizedContracts;

    /**
    * API
    */

    function authorizeContractCaller(address dataContract) external override requireContractOwner {
        authorizedContracts[dataContract] = true;
    }

    function deauthorizeContractCaller(address dataContract) external override requireContractOwner {
        delete authorizedContracts[dataContract];
    }

    /**
    * Modifiers and private methods
    */

    modifier requiredAuthorizedCaller() {
        require(authorizedContracts[msg.sender], "Caller is not authorized");
        _;
    }
}

