// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./base/BaseOracleListenerHandler.sol";
import "../shared/OwnableContract.sol";
import "../shared/PayableContract.sol";
import "./base/BaseAppContract.sol";

abstract contract OracleController is BaseOracleListenerHandler, BaseAppContract, OwnableContract, PayableContract {

    uint8 public constant ORACLE_RANDOM_INDEX_CEIL = 10;

    uint8 public constant BLOCKS_USED_FOR_RANDOM_NUMBER_GENERATION = 5;

    uint256 public constant ORACLE_REGISTRATION_FEE = 1 ether;

    uint256 private constant MIN_ORACLE_RESPONSES_REQUIRED_FOR_VALIDATION = 3;

    uint8 private randomNumberGeneratorNonce = 0;

    struct Oracle {
        bool isRegistered;
        uint8[3] indexes; // 0..9 0..9 0..9
    }

    mapping(address => Oracle) private oracles;

    struct OracleFlightStatusInfo {
        address requester;
        bool isOpen;
        mapping(uint8 => address[]) responses; // key = statusCode
    }

    // key = hash(index, flightNumber, departureTime)
    mapping(bytes32 => OracleFlightStatusInfo) private oracleFlightStatusInfos;

    /**
    * API
    */

    // old name: OracleRequest
    event OracleFlightStatusInfoRequested(uint8 index, address airlineAddress, string flightNumber, uint256 departureTime);

    // old name: OracleReport
    event OracleFlightStatusInfoSubmitted(address airlineAddress, string flightNumber, uint256 departureTime, uint8 flightStatus);

    // old name: FlightStatusInfo
    event FlightStatusInfoUpdated(address airlineAddress, string flightNumber, uint256 departureTime, uint8 flightStatus);

    function registerOracle() external payable {
        require(msg.value >= ORACLE_REGISTRATION_FEE, "Registration fee is required");

        uint8[3] memory indexes = generateThreeNonDuplicatedIndexes(msg.sender, ORACLE_RANDOM_INDEX_CEIL);

        oracles[msg.sender] = Oracle(
            true,
            indexes
        );
    }

    function unregisterOracle() external {
        require(oracles[msg.sender].isRegistered, "Only a registered oracle can be unregistered");
        delete oracles[msg.sender];

        payTo(msg.sender, ORACLE_REGISTRATION_FEE, "Cannot pay back the registration fee for oracle");
    }

    function getMyIndexes() view external returns (uint8[3] memory){
        require(oracles[msg.sender].isRegistered, "Not registered as an oracle");

        return oracles[msg.sender].indexes;
    }

    // Generate a request for oracles to fetch flightNumber information
    function requestOracleFlightStatusInfo(address airlineAddress, string calldata flightNumber, uint256 departureTime) external {
        uint8 index = getRandomIndex(msg.sender, ORACLE_RANDOM_INDEX_CEIL);

        // Generate a unique key for storing the request
        bytes32 oracleKey = getOracleKey(index, airlineAddress, flightNumber, departureTime);

        OracleFlightStatusInfo storage oracleFlightStatusInfo = oracleFlightStatusInfos[oracleKey];
        require(oracleFlightStatusInfo.requester == address(0), "The same oracle request to request flight information cannot be done twice");

        oracleFlightStatusInfo.isOpen = true;
        oracleFlightStatusInfo.requester = msg.sender;

        emit OracleFlightStatusInfoRequested(index, airlineAddress, flightNumber, departureTime);
    }

    // Called by oracle when a response is available to an outstanding request
    // For the response to be accepted, there must be a pending request that is open
    // and matches one of the three Indexes randomly assigned to the oracle at the
    // time of registration (i.e. uninvited oracles are not welcome)
    function submitOracleFlightStatusInfo(uint8 index, address airlineAddress, string calldata flightNumber, uint256 departureTime, uint8 statusCode) external {
        require((oracles[msg.sender].indexes[0] == index) || (oracles[msg.sender].indexes[1] == index) || (oracles[msg.sender].indexes[2] == index), "Index does not match oracle request");

        bytes32 oracleKey = getOracleKey(index, airlineAddress, flightNumber, departureTime);
        require(oracleFlightStatusInfos[oracleKey].isOpen, "Flight or departureTime do not match oracle request");

        oracleFlightStatusInfos[oracleKey].responses[statusCode].push(msg.sender);

        emit OracleFlightStatusInfoSubmitted(airlineAddress, flightNumber, departureTime, statusCode);

        if (oracleFlightStatusInfos[oracleKey].responses[statusCode].length >= MIN_ORACLE_RESPONSES_REQUIRED_FOR_VALIDATION) {
            oracleFlightStatusInfos[oracleKey].isOpen = false;
            processFlightStatusInfoUpdated(airlineAddress, flightNumber, departureTime, statusCode);
            emit FlightStatusInfoUpdated(airlineAddress, flightNumber, departureTime, statusCode);
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
