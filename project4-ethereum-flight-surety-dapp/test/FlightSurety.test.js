const {expectThrow} = require('./helpers/expectThrow');

var Test = require('../config/testConfig.js');
var BigNumber = require('bignumber.js');

contract('Flight Surety Tests', async (accounts) => {

    let config;

    let appContract;
    let dataContract;

    before('setup contract', async () => {
        config = await Test.Config(accounts);
        appContract = config.flightSuretyApp;
        dataContract = config.flightSuretyData;
    });

    /***********************************************************************************/
    /* Operational Status                                                              */
    /***********************************************************************************/

    describe('Test Operational Status', function () {
        it(`has correct initial isContractOperational() value`, async function () {
            assertIsContractOperational(true);
        });

        it(`can block access to pauseContract() for non-Contract Owner account`, async function () {
            await expectThrow(
                dataContract.pauseContract({from: config.testAddresses[2]}), "Caller is not contract owner"
            );
            assertIsContractOperational(true);
        });

        it(`can allow access to pauseContract() and resumeContract() for Contract Owner account`, async function () {
            dataContract.pauseContract();
            assertIsContractOperational(false);

            dataContract.resumeContract();
            assertIsContractOperational(true);
        });

        async function assertIsContractOperational(expectedStatus) {
            let status = await config.flightSuretyData.isContractOperational.call();
            assert.equal(status, expectedStatus, "Incorrected operational status");
        }
    });

    /***********************************************************************************/
    /* Airline Registration                                                            */
    /***********************************************************************************/

    describe('Test Airline Registration', function () {
        it('cannot register an Airline using registerAirline() if it is not funded', async () => {
            await expectThrow(
                config.flightSuretyApp.registerAirline(accounts[2], {from: config.firstAirline}), "Caller is not a fully qualified insurer"
            );
        });
    });

});
