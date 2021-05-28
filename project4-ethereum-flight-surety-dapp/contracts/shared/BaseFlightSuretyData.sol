// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseOperationalContract.sol";
import "./BaseCallableContract.sol";
import "./BaseInsurer.sol";
import "./BaseInsuree.sol";

interface BaseFlightSuretyData is BaseOperationalContract, BaseCallableContract, BaseInsurer, BaseInsuree {
}


