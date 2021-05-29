// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseOperationalContract.sol";
import "./BaseCallableContract.sol";
import "./BaseInsurerController.sol";
import "./BaseInsuranceController.sol";

interface BaseFlightSuretyData is BaseOperationalContract, BaseCallableContract, BaseInsurerController, BaseInsuranceController {
}


