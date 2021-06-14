// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./base/BaseDataContract.sol";
import "../shared/OwnableContract.sol";

abstract contract DataContract is BaseDataContract, OwnableContract {

    mapping(address => bool) private authorizedContracts;

    struct Funding {
        address sponsorAddress;
        uint amountPaid;
    }

    Funding[] private fundings;

    /**
    * API
    */

    event FundingReceived(address sponsorAddress, uint amountPaid);

    receive() external payable {
        Funding memory funding = Funding(
            msg.sender,
            msg.value
        );

        fundings.push(funding);
        emit FundingReceived(msg.sender, msg.value);
    }

    function authorizeContractCaller(address dataContract) external override requireContractOwner {
        authorizedContracts[dataContract] = true;
    }

    function deauthorizeContractCaller(address dataContract) external override requireContractOwner {
        delete authorizedContracts[dataContract];
    }

    /**
    * Modifiers and private methods
    */

    modifier requireAuthorizedCaller() {
        require(authorizedContracts[msg.sender], "Caller is not authorized");
        _;
    }
}

