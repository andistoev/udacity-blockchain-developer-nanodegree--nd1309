// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseCallableContract {
    function enableContractCaller(address dataContract) external;

    function disableContractCaller(address dataContract) external;
}
