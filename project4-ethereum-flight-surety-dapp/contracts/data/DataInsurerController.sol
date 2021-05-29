// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/BaseInsurerController.sol";
import "../shared/PayableContract.sol";
import "./DataOperationalContract.sol";

abstract contract DataInsurerController is PayableContract, DataOperationalContract, BaseInsurerController, DataContract {

    uint private constant INSURER_FEE = 10 ether;

    enum InsurerState{
        UNREGISTERED, // 0
        REGISTERED, // 1
        APPROVED, // 2
        FULLY_QUALIFIED // 3
    }

    struct InsurerProfile {
        string name;
        InsurerState state;
        uint16 approversCtr;
        mapping(address => bool) approvers;
    }

    uint16 private constant NUMBER_OF_FULLY_QUALIFIED_INSURERS_REQUIRED_FOR_MULTI_PARITY_CONSENSUS = 5;

    uint16 fullyQualifiedInsurersCtr;
    mapping(address => InsurerProfile) private insurers;

    /**
    * API
    */

    event InsurerStateChanged(address insurerAddress, string name, uint state);

    function registerInsurer(address insurerAddress, string memory insurerName) external override requireIsOperational requiredFullyQualifiedInsurer requiredAuthorizedCaller {
        require(insurers[insurerAddress].state == InsurerState.UNREGISTERED, "Insurer is already registered");

        insurers[insurerAddress].name = insurerName;
        insurers[insurerAddress].state = InsurerState.REGISTERED;

        triggerInsurerStateChange(insurerAddress);
    }

    function approveInsurer(address insurerAddress) external override requireIsOperational requiredFullyQualifiedInsurer requiredAuthorizedCaller {
        require(insurers[insurerAddress].state == InsurerState.REGISTERED, "Insurer is not yet registered or has been already approved");
        require(insurers[insurerAddress].approvers[msg.sender] == false, "Insurer has been already approved by this caller");

        insurers[insurerAddress].approvers[msg.sender] = true;
        insurers[insurerAddress].approversCtr++;

        if (isInsurerApproved(insurerAddress)) {
            insurers[insurerAddress].state = InsurerState.APPROVED;
            triggerInsurerStateChange(insurerAddress);
        }
    }

    function payInsurerFee() external payable override requireIsOperational giveChangeBack(INSURER_FEE) requiredAuthorizedCaller {
        require(insurers[msg.sender].state == InsurerState.APPROVED, "Insurer is not yet approved or has been already approved");
        require(msg.value >= INSURER_FEE, "Insufficient insurer's fee");

        insurers[msg.sender].state = InsurerState.FULLY_QUALIFIED;
        fullyQualifiedInsurersCtr++;

        triggerInsurerStateChange(msg.sender);
    }

    /**
    * Modifiers and private methods
    */

    modifier requiredFullyQualifiedInsurer(){
        require(insurers[msg.sender].state == InsurerState.FULLY_QUALIFIED, "Caller is not a fully qualified insurer");
        _;
    }

    function isInsurerApproved(address insurerAddress) private view returns (bool) {
        if (fullyQualifiedInsurersCtr < NUMBER_OF_FULLY_QUALIFIED_INSURERS_REQUIRED_FOR_MULTI_PARITY_CONSENSUS) {
            return true;
        }

        return insurers[insurerAddress].approversCtr * 2 >= fullyQualifiedInsurersCtr;
    }

    function triggerInsurerStateChange(address insurerAddress) private {
        emit InsurerStateChanged(insurerAddress, insurers[insurerAddress].name, uint(insurers[insurerAddress].state));
    }

}
