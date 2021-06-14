// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./BaseOperationalContract.sol";
import "../data/base/BaseDataContract.sol";
import "../data/base/BaseDataInsurerController.sol";
import "../data/base/BaseDataInsuranceController.sol";

interface BaseSuretyData is BaseOperationalContract, BaseDataContract, BaseDataInsurerController, BaseDataInsuranceController {
}


