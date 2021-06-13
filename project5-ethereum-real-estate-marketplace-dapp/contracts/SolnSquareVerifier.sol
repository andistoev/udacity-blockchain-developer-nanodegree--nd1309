// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./ERC721Mintable.sol";
import "./ISquareVerifier.sol";

contract SolnSquareVerifier is PrivacyAssuredRealEstateOwnershipToken {

    event SolutionAdded(uint256 index);

    ISquareVerifier private squareVerifier;

    struct Solution {
        address solutionOwner;
        uint256 tokenId;
        bool isRegistered;
        bool isMinted;
    }

    mapping(bytes32 => Solution) private solutions;

    constructor(address squareVerifierAddress) PrivacyAssuredRealEstateOwnershipToken() public {
        squareVerifier = ISquareVerifier(squareVerifierAddress);
    }

    function registerSolution(uint256 tokenId, uint[2] memory input, uint[2] memory a, uint[2][2] memory b, uint[2] memory c) public {
        bytes32 key = getSolutionKey(input);

        require(!solutions[key].isRegistered, "A solution can not be registered twice");
        require(squareVerifier.verifyTx(a, b, c, input), "The verification submitted failed");

        solutions[key] = Solution(msg.sender, tokenId, true, false);

        emit SolutionAdded(tokenId);
    }

    function mintPrivacyAssuredRealEstateOwnershipToken(address to, uint256 tokenId, uint[2] memory input) public {
        bytes32 key = getSolutionKey(input);

        require(msg.sender == solutions[key].solutionOwner, "Only the solution's owner is allowed to mint a solution");
        require(solutions[key].isRegistered, "Can not be minted a solution which does not exist");
        require(solutions[key].tokenId == tokenId, "Can not be minted a solution with different tokenId");
        require(!solutions[key].isMinted, "A solution can not be minted twice");

        mint(to, tokenId);
        solutions[key].isMinted = true;
    }

    function getSolutionKey(uint[2] memory input) private pure returns (bytes32){
        return keccak256(abi.encodePacked(input[0], input[1]));
    }
}
