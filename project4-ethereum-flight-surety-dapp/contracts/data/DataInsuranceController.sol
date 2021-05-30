// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/PayableContract.sol";
import "./DataOperationalContract.sol";
import "../shared/BaseDataInsuranceController.sol";
import "./DataContract.sol";

abstract contract DataInsuranceController is PayableContract, DataOperationalContract, BaseDataInsuranceController, DataContract {

    // configurable parameters by contract owner
    uint private minInsurancePrice = 1 wei;
    uint private maxInsurancePrice = 1 ether;

    enum InsurancePolicyState{
        AVAILABLE, // 0
        OPEN, // 1
        CLOSED_NO_MONEY_BACK, // 2
        CREDIT_APPROVED, // 3
        CREDIT_WITHDRAWN // 4
    }

    struct InsurancePolicy {
        InsurancePolicyState state;
        uint amountPaid;
        uint amountWithdrawn;
    }

    struct InsuredObject {
        bool isRegistered;
        mapping(address => InsurancePolicy) insurancePolicies;
        address[] insureeAddresses;
    }

    // key = insuredObjectKey
    mapping(bytes32 => InsuredObject) private insuredObjects;

    /**
    * API
    */

    event InsurancePolicyStateChanged(address insureeAddress, bytes32 insuredObjectKey, uint state);

    function setInsuranceConfigParams(uint _minInsurancePrice, uint _maxInsurancePrice) external override requireContractOwner {
        minInsurancePrice = _minInsurancePrice;
        maxInsurancePrice = _maxInsurancePrice;
    }

    function registerInsuredObject(bytes32 insuredObjectKey) external override requireIsOperational requireAuthorizedCaller {
        require(!insuredObjects[insuredObjectKey].isRegistered, "An insured object can not be registered twice");
        insuredObjects[insuredObjectKey].isRegistered = true;
    }

    function buyInsurance(address insureeAddress, bytes32 insuredObjectKey) external payable override requireIsOperational requireAuthorizedCaller {
        require(msg.value >= minInsurancePrice && msg.value <= maxInsurancePrice, "Invalid insurance price paid");

        InsuredObject storage insuredObject = insuredObjects[insuredObjectKey];
        require(insuredObject.isRegistered, "The insured object is not registered");
        require(insuredObject.insurancePolicies[insureeAddress].state == InsurancePolicyState.AVAILABLE, "The same policy can not be bought twice");

        insuredObject.insurancePolicies[insureeAddress] = InsurancePolicy(
            InsurancePolicyState.OPEN,
            getInsureePaidAmount(),
            0
        );

        insuredObject.insureeAddresses.push(insureeAddress);

        triggerInsurancePolicyStateChange(insuredObjectKey, insureeAddress);
    }

    function closeAllInsurances(bytes32 insuredObjectKey) external override requireIsOperational requireAuthorizedCaller {
        InsuredObject storage insuredObject = insuredObjects[insuredObjectKey];
        require(insuredObject.isRegistered, "The insured object is not registered");

        for (uint i = 0; i < insuredObject.insureeAddresses.length; i++) {
            address insureeAddress = insuredObject.insureeAddresses[i];
            InsurancePolicy storage insurancePolicy = insuredObject.insurancePolicies[insureeAddress];
            require(insurancePolicy.state == InsurancePolicyState.OPEN, "Insurance can not be closed or it has been already closed");
            insurancePolicy.state = InsurancePolicyState.CLOSED_NO_MONEY_BACK;
            triggerInsurancePolicyStateChange(insuredObjectKey, insureeAddress);
        }
    }

    function approveAllInsuranceCreditWithdraws(bytes32 insuredObjectKey) external override requireIsOperational requireAuthorizedCaller {
        InsuredObject storage insuredObject = insuredObjects[insuredObjectKey];
        require(insuredObject.isRegistered, "The insured object is not registered");

        for (uint i = 0; i < insuredObject.insureeAddresses.length; i++) {
            address insureeAddress = insuredObject.insureeAddresses[i];
            InsurancePolicy storage insurancePolicy = insuredObject.insurancePolicies[insureeAddress];
            require(insurancePolicy.state == InsurancePolicyState.OPEN, "Credit retrieval can not be approved or it has been already approved");
            insurancePolicy.state = InsurancePolicyState.CREDIT_APPROVED;
            triggerInsurancePolicyStateChange(insuredObjectKey, insureeAddress);
        }
    }

    function withdrawInsuranceCredit(address insureeAddress, bytes32 insuredObjectKey) external payable override requireIsOperational requireAuthorizedCaller {
        InsuredObject storage insuredObject = insuredObjects[insuredObjectKey];
        require(insuredObject.isRegistered, "The insured object is not registered");

        InsurancePolicy storage insurancePolicy = insuredObject.insurancePolicies[insureeAddress];
        require(insurancePolicy.state == InsurancePolicyState.CREDIT_APPROVED, "Credit retrieval is not approved or it has been already withdrawn");
        require(insurancePolicy.amountWithdrawn == 0, "Credit can not be withdrawn twice");

        insurancePolicy.amountWithdrawn = insurancePolicy.amountPaid * 3 / 2;
        insurancePolicy.state = InsurancePolicyState.CREDIT_WITHDRAWN;

        payTo(insureeAddress, insurancePolicy.amountWithdrawn, "Insurance policy credit withdrawn failed.");
        triggerInsurancePolicyStateChange(insuredObjectKey, insureeAddress);
    }

    /**
    * Modifiers and private methods
    */

    function getInsureePaidAmount() private view returns (uint){
        if (msg.value >= maxInsurancePrice) {
            return maxInsurancePrice;
        }

        return msg.value;
    }

    function triggerInsurancePolicyStateChange(bytes32 insuredObjectKey, address insureeAddress) private {
        InsuredObject storage insuredObject = insuredObjects[insuredObjectKey];
        emit InsurancePolicyStateChanged(insureeAddress, insuredObjectKey, uint(insuredObject.insurancePolicies[insureeAddress].state));
    }

}
