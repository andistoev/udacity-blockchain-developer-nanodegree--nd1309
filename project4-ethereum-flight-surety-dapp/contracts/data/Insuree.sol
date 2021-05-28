// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseInsuree.sol";
import "./PayableContract.sol";

abstract contract Insuree is BaseInsuree, PayableContract {

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

    event InsurancePolicyStateChanged(address insureeAddress, string name, uint state);

    mapping(string => mapping(address => InsurancePolicy)) private insurancePolicies;

    function buyInsurance(string calldata insuredObjectId) external payable override giveChangeBack(MAX_INSURANCE_PRICE) {
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

    function getInsureePaidAmount() private view returns (uint){
        if (msg.value >= MAX_INSURANCE_PRICE) {
            return MAX_INSURANCE_PRICE;
        }

        return msg.value;
    }

    function withdrawInsuranceCredit(string calldata insuredObjectId) external payable override {
        InsurancePolicy storage insurancePolicy = insurancePolicies[insuredObjectId][msg.sender];

        require(insurancePolicy.state == InsurancePolicyState.CREDIT_APPROVED, "Credit retrieval is not approved or it has been already withdrawn");

        uint creditAmount = insurancePolicy.amountPaid * 3 / 2;
        insurancePolicy.amountWithdrawn = creditAmount;
        insurancePolicy.state = InsurancePolicyState.CREDIT_WITHDRAWN;

        (bool success,) = msg.sender.call{value : creditAmount}("");
        require(success, "Insurance policy credit withdrawn failed.");

        triggerInsurancePolicyStateChange(insuredObjectId, msg.sender);
    }

    function triggerInsurancePolicyStateChange(string calldata insuredObjectId, address insureeAddress) private {
        emit InsurancePolicyStateChanged(insureeAddress, insuredObjectId, uint(insurancePolicies[insuredObjectId][insureeAddress].state));
    }
}
