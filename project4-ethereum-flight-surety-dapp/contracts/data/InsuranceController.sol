// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseInsuranceController.sol";
import "../shared/PayableContract.sol";
import "./OperationalContractData.sol";

abstract contract InsuranceController is PayableContract, OperationalContractData, BaseInsuranceController {

    uint private constant MAX_INSURANCE_PRICE = 1 ether;

    enum InsurancePolicyState{
        AVAILABLE, // 0
        OPEN, // 1
        CLOSED, // 2
        CREDIT_APPROVED, // 3
        CREDIT_WITHDRAWN // 4
    }

    struct InsurancePolicy {
        InsurancePolicyState state;
        uint amountPaid;
        uint amountWithdrawn;
    }

    // insuredObjectId => mapping(insureeAddress => insurancePolicy)
    mapping(string => mapping(address => InsurancePolicy)) private insurancePolicies;

    /**
    * API
    */

    event InsurancePolicyStateChanged(address insureeAddress, string name, uint state);

    function buyInsurance(string calldata insuredObjectId) external payable override requireIsOperational giveChangeBack(MAX_INSURANCE_PRICE) {
        require(bytes(insuredObjectId).length > 0, 'InsuredObjectId is invalid identifier');
        require(msg.value > 0, "Insurance policy's price can not be 0");
        require(insurancePolicies[insuredObjectId][msg.sender].state == InsurancePolicyState.AVAILABLE, "The same policy can not be bought twice");

        insurancePolicies[insuredObjectId][msg.sender] = InsurancePolicy(
            InsurancePolicyState.OPEN,
            getInsureePaidAmount(),
            0
        );

        triggerInsurancePolicyStateChange(insuredObjectId, msg.sender);
    }

    function withdrawInsuranceCredit(string memory insuredObjectId) external payable override requireIsOperational {
        InsurancePolicy storage insurancePolicy = insurancePolicies[insuredObjectId][msg.sender];

        require(insurancePolicy.state == InsurancePolicyState.CREDIT_APPROVED, "Credit retrieval is not approved or it has been already withdrawn");
        require(insurancePolicy.amountWithdrawn == 0, "Credit can not be withdrawn twice");

        insurancePolicy.amountWithdrawn = insurancePolicy.amountPaid * 3 / 2;
        insurancePolicy.state = InsurancePolicyState.CREDIT_WITHDRAWN;

        triggerInsurancePolicyStateChange(insuredObjectId, msg.sender);

        payTo(msg.sender, insurancePolicy.amountWithdrawn, "Insurance policy credit withdrawn failed.");
    }

    /**
    * Modifiers and private methods
    */

    function getInsureePaidAmount() private view returns (uint){
        if (msg.value >= MAX_INSURANCE_PRICE) {
            return MAX_INSURANCE_PRICE;
        }

        return msg.value;
    }

    function triggerInsurancePolicyStateChange(string memory insuredObjectId, address insureeAddress) private {
        emit InsurancePolicyStateChanged(insureeAddress, insuredObjectId, uint(insurancePolicies[insuredObjectId][insureeAddress].state));
    }

}
