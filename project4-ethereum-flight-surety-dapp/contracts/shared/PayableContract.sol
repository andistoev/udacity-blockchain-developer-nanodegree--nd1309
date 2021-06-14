// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

abstract contract PayableContract {

    function payTo(address payee, uint amount, string memory messageOnFailure) internal {
        require(payee != address(0), "The payee is not a valid address");
        require(amount > 0, "Only positive credit amount can be withdrawn");

        (bool success,) = payee.call{value : amount}("");
        require(success, messageOnFailure);
    }
}

