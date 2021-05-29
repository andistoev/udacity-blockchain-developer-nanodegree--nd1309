// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../shared/OwnableContract.sol";

abstract contract OracleController is OwnableContract {

    uint8 public constant ORACLE_RANDOM_INDEX_CEIL = 10;

    uint256 public constant ORACLE_REGISTRATION_FEE = 1 ether;

    uint256 private constant MIN_ORACLE_RESPONSES_REQUIRED_FOR_VALIDATION = 3;

    uint8 private randomNumberGeneratorNonce = 0;

    struct Oracle {
        bool isRegistered;
        uint8[3] indexes; // 0..9 0..9 0..9
    }

    mapping(address => Oracle) private oracles;

    struct OracleResponse {
        address requester;
        bool isOpen;
        mapping(uint8 => address[]) responses;
    }

    // key = hash(index, flight, timestamp)
    mapping(bytes32 => OracleResponse) private oracleResponses;

    /**
    * API
    */

    // Event fired each time an oracle submits a response
    event FlightStatusInfo(address airline, string flight, uint256 timestamp, uint8 status);

    event OracleReport(address airline, string flight, uint256 timestamp, uint8 status);

    // Event fired when flight status request is submitted
    // Oracles track this and if they have a matching index
    // they fetch data and submit a response
    event OracleRequest(uint8 index, address airline, string flight, uint256 timestamp);

    function registerOracle() external payable {
        require(msg.value >= ORACLE_REGISTRATION_FEE, "Registration fee is required");

        uint8[3] memory indexes = generateThreeNonDuplicatedIndexes(msg.sender, ORACLE_RANDOM_INDEX_CEIL);

        oracles[msg.sender] = Oracle(
            true,
            indexes
        );
    }

    function getMyIndexes() view external returns (uint8[3] memory){
        require(oracles[msg.sender].isRegistered, "Not registered as an oracle");

        return oracles[msg.sender].indexes;
    }

    // Generate a request for oracles to fetch flight information
    function fetchFlightStatus(address airline, string calldata flight, uint256 timestamp) external {
        uint8 index = getRandomIndex(msg.sender, ORACLE_RANDOM_INDEX_CEIL);

        // Generate a unique key for storing the request
        bytes32 key = getOracleKey(index, airline, flight, timestamp);

        OracleResponse storage oracleResponse = oracleResponses[key];
        require(oracleResponse.requester == address(0), "The same oracle request to fetch flight information can not be done twice");

        oracleResponse.isOpen = true;
        oracleResponse.requester = msg.sender;

        emit OracleRequest(index, airline, flight, timestamp);
    }

    // Called by oracle when a response is available to an outstanding request
    // For the response to be accepted, there must be a pending request that is open
    // and matches one of the three Indexes randomly assigned to the oracle at the
    // time of registration (i.e. uninvited oracles are not welcome)
    function submitOracleResponse(uint8 index, address airline, string calldata flight, uint256 timestamp, uint8 statusCode) external {
        require((oracles[msg.sender].indexes[0] == index) || (oracles[msg.sender].indexes[1] == index) || (oracles[msg.sender].indexes[2] == index), "Index does not match oracle request");

        bytes32 key = getOracleKey(index, airline, flight, timestamp);
        require(oracleResponses[key].isOpen, "Flight or timestamp do not match oracle request");

        oracleResponses[key].responses[statusCode].push(msg.sender);

        emit OracleReport(airline, flight, timestamp, statusCode);

        if (oracleResponses[key].responses[statusCode].length >= MIN_ORACLE_RESPONSES_REQUIRED_FOR_VALIDATION) {
            oracleResponses[key].isOpen = false;
            emit FlightStatusInfo(airline, flight, timestamp, statusCode);
            processFlightStatus(airline, flight, timestamp, statusCode);
        }
    }

    /**
    * Modifiers and private methods
    */

    function processFlightStatus(address airline, string memory flight, uint256 timestamp, uint8 statusCode) private pure {
    }

    function getOracleKey(uint8 index, address airline, string calldata flight, uint256 timestamp) pure private returns (bytes32){
        return keccak256(abi.encodePacked(index, airline, flight, timestamp));
    }

    function getFlightKey(address airline, string calldata flight, uint256 timestamp) pure private returns (bytes32){
        return keccak256(abi.encodePacked(airline, flight, timestamp));
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
        randomNumberGeneratorNonce = (randomNumberGeneratorNonce + 1) % 5;
        return random;
    }

}

