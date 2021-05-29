// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseOperationalContract.sol";
import "./BaseDataContract.sol";
import "./BaseInsurerController.sol";
import "./BaseInsuranceController.sol";

interface BaseFlightSuretyData is BaseOperationalContract, BaseDataContract, BaseInsurerController, BaseInsuranceController {
}


