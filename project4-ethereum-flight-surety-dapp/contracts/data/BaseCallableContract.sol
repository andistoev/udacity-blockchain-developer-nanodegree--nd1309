// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseCallableContract {
    function authorizeContractCaller(address dataContract) external;

    function deauthorizeContractCaller(address dataContract) external;
}
