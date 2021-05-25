// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

interface BaseInsurer {
    function registerInsurer() external pure;

    function payInsurersFee() external payable;
}
