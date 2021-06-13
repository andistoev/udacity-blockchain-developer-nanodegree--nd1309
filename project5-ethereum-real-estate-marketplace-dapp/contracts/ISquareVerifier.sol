// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.5;

interface ISquareVerifier {
    function verifyTx(uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[2] memory input) external view returns (bool r);
}
