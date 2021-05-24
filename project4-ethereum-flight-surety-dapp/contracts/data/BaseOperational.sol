// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

interface BaseOperational {
    function isOperational() external view returns (bool);

    function setOperatingStatus(bool mode) external;
}
