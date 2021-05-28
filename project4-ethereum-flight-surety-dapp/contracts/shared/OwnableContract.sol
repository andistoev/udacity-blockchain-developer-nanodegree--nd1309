// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract OwnableContract {

    address private contractOwner;

    constructor() {
        contractOwner = msg.sender;
    }

    modifier requireContractOwner () {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }
}

