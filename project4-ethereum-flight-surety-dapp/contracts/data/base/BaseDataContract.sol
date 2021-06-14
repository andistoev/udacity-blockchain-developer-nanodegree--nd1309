// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

interface BaseDataContract {
    function authorizeContractCaller(address dataContract) external;

    function deauthorizeContractCaller(address dataContract) external;
}
