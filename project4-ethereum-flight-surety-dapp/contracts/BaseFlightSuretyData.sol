// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./data/BaseOperationalContract.sol";
import "./data/BaseCallableContract.sol";
import "./data/BaseInsurer.sol";
import "./data/BaseInsuree.sol";

interface BaseFlightSuretyData is BaseOperationalContract, BaseCallableContract, BaseInsurer, BaseInsuree {
}


