// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./base/BaseOracleListenerHandler.sol";
import "../shared/OwnableContract.sol";
import "../shared/PayableContract.sol";
import "./base/BaseAppContract.sol";
import "./base/BaseAppInsuranceController.sol";

abstract contract OracleController is BaseAppInsuranceController, BaseOracleListenerHandler, BaseAppContract, OwnableContract, PayableContract {

    uint8 public constant ORACLE_RANDOM_INDEX_CEIL = 10;

    uint8 public constant BLOCKS_USED_FOR_RANDOM_NUMBER_GENERATION = 5;

    uint256 public constant ORACLE_REGISTRATION_FEE = 1 ether;

    uint256 public constant ORACLE_RESPONSES_REQUIRED_FOR_VALIDATION = 3;

    uint8 private randomNumberGeneratorNonce = 0;

    struct Oracle {
        bool isRegistered;
        uint8[3] indexes; // 0..9 0..9 0..9
    }

    mapping(address => Oracle) private oracles;

    struct FlightStatusInfo {
        bool isRequested;
        address requester;
        bool isOpen;
        mapping(uint8 => address[]) responses; // key = statusCode
    }

    // key = hash(index, flightNumber, departureTime)
    mapping(bytes32 => FlightStatusInfo) private oracleFlightStatusInfos;

    /**
    * API
    */

    event OracleRegistered(address oracleAddress);

    // old name: OracleRequest
    event FlightStatusInfoRequested(uint8 index, address airlineAddress, string flightNumber, uint256 departureTime);

    // old name: OracleReport
    event FlightStatusInfoSubmitted(address airlineAddress, string flightNumber, uint256 departureTime, uint8 flightStatus);

    // old name: FlightStatusInfo
    event FlightStatusInfoUpdated(address airlineAddress, string flightNumber, uint256 departureTime, uint8 flightStatus);

    function registerOracle() external payable requireIsOperational {
        require(msg.value >= ORACLE_REGISTRATION_FEE, "Registration fee is required");

        uint8[3] memory indexes = generateThreeNonDuplicatedIndexes(msg.sender, ORACLE_RANDOM_INDEX_CEIL);

        oracles[msg.sender] = Oracle(
            true,
            indexes
        );

        emit OracleRegistered(msg.sender);
    }

    function unregisterOracle() external requireIsOperational {
        require(oracles[msg.sender].isRegistered, "Only a registered oracle can be unregistered");
        delete oracles[msg.sender];

        payTo(msg.sender, ORACLE_REGISTRATION_FEE, "Cannot pay back the registration fee for oracle");
    }

    function getMyIndexes() view external returns (uint8[3] memory){
        require(oracles[msg.sender].isRegistered, "Not registered as an oracle");

        return oracles[msg.sender].indexes;
    }

    // Generate a request for oracles to fetch flightNumber information
    function requestFlightStatusInfo(address airlineAddress, string calldata flightNumber, uint256 departureTime) external requireIsOperational {
        bytes32 flightKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        requireRegisteredFlight(flightKey);
        requireNotClosedFlight(flightKey);

        uint8 index = getRandomIndex(msg.sender, ORACLE_RANDOM_INDEX_CEIL);

        // Generate a unique key for storing the request
        bytes32 oracleKey = getOracleKey(index, airlineAddress, flightNumber, departureTime);
        FlightStatusInfo storage oracleFlightStatusInfo = oracleFlightStatusInfos[oracleKey];

        require(!oracleFlightStatusInfo.isRequested, "Can not request flight status info with the same index twice");

        require(oracleFlightStatusInfo.requester == address(0), "The same oracle request to request flight information cannot be done twice");

        oracleFlightStatusInfo.isRequested = true;
        oracleFlightStatusInfo.requester = msg.sender;
        oracleFlightStatusInfo.isOpen = true;

        emit FlightStatusInfoRequested(index, airlineAddress, flightNumber, departureTime);
    }

    // Called by oracle when a response is available to an outstanding request
    // For the response to be accepted, there must be a pending request that is open
    // and matches one of the three Indexes randomly assigned to the oracle at the
    // time of registration (i.e. uninvited oracles are not welcome)
    function submitFlightStatusInfo(uint8 index, address airlineAddress, string calldata flightNumber, uint256 departureTime, uint8 statusCode) external requireIsOperational {
        bytes32 flightKey = getFlightKey(airlineAddress, flightNumber, departureTime);
        requireRegisteredFlight(flightKey);
        requireNotClosedFlight(flightKey);

        require((oracles[msg.sender].indexes[0] == index) || (oracles[msg.sender].indexes[1] == index) || (oracles[msg.sender].indexes[2] == index), "Index does not match oracle request");

        bytes32 oracleKey = getOracleKey(index, airlineAddress, flightNumber, departureTime);
        require(oracleFlightStatusInfos[oracleKey].isRequested, "The submitted flight status information has never been requested");
        require(oracleFlightStatusInfos[oracleKey].isOpen, "The flight status information request has been closed");

        oracleFlightStatusInfos[oracleKey].responses[statusCode].push(msg.sender);

        emit FlightStatusInfoSubmitted(airlineAddress, flightNumber, departureTime, statusCode);

        if (oracleFlightStatusInfos[oracleKey].responses[statusCode].length >= ORACLE_RESPONSES_REQUIRED_FOR_VALIDATION) {
            closeFlight(flightKey);
            oracleFlightStatusInfos[oracleKey].isOpen = false;
            emit FlightStatusInfoUpdated(airlineAddress, flightNumber, departureTime, statusCode);
            processFlightStatusInfoUpdated(airlineAddress, flightNumber, departureTime, statusCode);
        }
    }

    /**
    * Modifiers and private methods
    */

    function getOracleKey(uint8 index, address airlineAddress, string calldata flightNumber, uint256 departureTime) pure private returns (bytes32){
        return keccak256(abi.encodePacked(index, airlineAddress, flightNumber, departureTime));
    }

    function generateThreeNonDuplicatedIndexes(address account, uint8 randomNumberIndexCeil) private returns (uint8[3] memory){
        uint8[3] memory indexes;

        indexes[0] = getRandomIndex(account, randomNumberIndexCeil);
        indexes[1] = getRandomIndex(account, randomNumberIndexCeil - 1);
        indexes[2] = getRandomIndex(account, randomNumberIndexCeil - 2);

        if (indexes[1] == indexes[0]) {
            indexes[1] = (indexes[1] + 1) % randomNumberIndexCeil;
        }

        if (indexes[2] == indexes[0]) {
            indexes[2] = (indexes[2] + 1) % randomNumberIndexCeil;
        }

        if (indexes[2] == indexes[1]) {
            indexes[2] = (indexes[2] + 1) % randomNumberIndexCeil;
        }

        return indexes;
    }

    function getRandomIndex(address account, uint8 randomNumberIndexCeil) private returns (uint8){
        uint8 random = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - randomNumberGeneratorNonce), randomNumberGeneratorNonce, account))) % randomNumberIndexCeil);
        randomNumberGeneratorNonce = (randomNumberGeneratorNonce + 1) % BLOCKS_USED_FOR_RANDOM_NUMBER_GENERATION;
        return random;
    }

}
