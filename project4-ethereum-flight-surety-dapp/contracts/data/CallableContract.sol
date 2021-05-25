// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "./BaseCallableContract.sol";

abstract contract CallableContract is BaseCallableContract {

    function enableContractCaller(address dataContract) external override {

    }

    function disableContractCaller(address dataContract) external override {

    }
}

