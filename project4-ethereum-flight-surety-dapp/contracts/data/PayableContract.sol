// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract PayableContract {

    modifier giveChangeBack(uint amountRequested) {
        _;
        uint amountToReturn = msg.value - amountRequested;
        payable(msg.sender).transfer(amountToReturn);
    }
}

