// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface BaseDataInsurerController {
    function setInsurerConfigParams(uint _insurerFee, uint _numberOfFullyQualifiedInsurersRequiredForMultiParityConsensus) external;

    function registerTheFirstFullyQualifiedInsurer(address insurerAddress, string memory insurerName) external;

    function registerInsurer(address approverInsurerAddress, address insurerAddress, string memory insurerName) external;

    function approveInsurer(address approverInsurerAddress, address insurerAddress) external;

    function payInsurerFee(address insurerAddress) external payable;
}
