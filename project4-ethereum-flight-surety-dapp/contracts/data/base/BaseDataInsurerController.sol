// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

interface BaseDataInsurerController {
    function setInsurerConfigParams(uint _insurerFee, uint _numberOfFullyQualifiedInsurersRequiredForMultiParityConsensus) external;

    function getInsurerFee() external view returns (uint);

    function getNumberOfFullyQualifiedInsurersRequiredForMultiParityConsensus() external view returns (uint);

    function registerTheFirstInsurer(address insurerAddress) external;

    function registerInsurer(address approverInsurerAddress, address insurerAddress) external;

    function payInsurerFee(address insurerAddress) external payable;
}
