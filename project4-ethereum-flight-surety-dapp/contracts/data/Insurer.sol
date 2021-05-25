// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseInsurer.sol";

abstract contract Insurer is BaseInsurer {

    uint private insurerFee = 1 ether;

    enum InsurerState{
        UNREGISTERED, // 0
        REGISTERED, // 1
        APPROVED, // 2
        FULLY_QUALIFIED // 3
    }

    struct InsurerProfile {
        string name;
        InsurerState state;
    }

    event InsurerStateChanged(address insurrerAddress, string name, uint state);

    mapping(address => InsurerProfile) private insurers;

    modifier requiredFullyQualifiedInsurer(){
        require(insurers[msg.sender].state == InsurerState.FULLY_QUALIFIED, "Caller is not a fully qualified insurer");
        _;
    }

    function registerInsurer(address insurerAddress, string memory insurerName) external override requiredFullyQualifiedInsurer {
        require(insurers[insurerAddress].state == InsurerState.UNREGISTERED, "Insurer is already registered");

        insurers[insurerAddress] = InsurerProfile({
        name : insurerName,
        state : InsurerState.REGISTERED
        });
        triggerStateChange(insurerAddress);
    }

    function approveInsurer(address insurerAddress) external override requiredFullyQualifiedInsurer {
        require(insurers[insurerAddress].state == InsurerState.REGISTERED, "Insurer is not yet registered or has been already approved");
        insurers[insurerAddress].state = InsurerState.APPROVED;
        triggerStateChange(insurerAddress);
    }

    modifier changeBackPlease(uint amountRequested) {
        _;
        uint amountToReturn = msg.value - amountRequested;
        payable(msg.sender).transfer(amountToReturn);
    }

    function payInsurerFee() external payable override changeBackPlease(insurerFee) {
        require(insurers[msg.sender].state == InsurerState.APPROVED, "Insurer is not yet approved or has been already approved");
        require(msg.value >= insurerFee, "Insufficient insurer's fee");
        insurers[msg.sender].state = InsurerState.FULLY_QUALIFIED;
        triggerStateChange(msg.sender);
    }

    function triggerStateChange(address insurerAddress) private {
        emit InsurerStateChanged(insurerAddress, insurers[insurerAddress].name, uint(insurers[insurerAddress].state));
    }
}

