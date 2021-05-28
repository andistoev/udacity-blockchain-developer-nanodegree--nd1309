// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseOperationalContract.sol";
import "./BaseCallableContract.sol";
import "./BaseInsurerManager.sol";
import "./BaseInsuranceManager.sol";

interface BaseFlightSuretyData is BaseOperationalContract, BaseCallableContract, BaseInsurerManager, BaseInsuranceManager {
}


