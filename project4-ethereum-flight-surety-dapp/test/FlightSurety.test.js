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

    /****************************************************************************************/
    /* Operations and Settings                                                              */
    /****************************************************************************************/

    it(`(multiparty) has correct initial isContractOperational() value`, async function () {
        assert.equal(await config.flightSuretyData.isContractOperational.call(), true, "Incorrect initial operating status value");
    });

    it(`(multiparty) can block access to pauseContract() for non-Contract Owner account`, async function () {
        await expectThrow(
            dataContract.pauseContract({from: config.testAddresses[2]}), "Caller is not contract owner"
        );
        assert.equal(await config.flightSuretyData.isContractOperational.call(), true, "Incorrect initial operating status value");
    });

    it(`(multiparty) can allow access to pauseContract() for Contract Owner account`, async function () {
        dataContract.pauseContract();
        assert.equal(await config.flightSuretyData.isContractOperational.call(), false, "Incorrect initial operating status value");
    });

    it(`(multiparty) can block access to functions using requireIsOperational when operating status is false`, async function () {

        await config.flightSuretyData.pauseContract();

        let reverted = false;
        try {
            await config.flightSurety.setTestingMode(true);
        } catch (e) {
            reverted = true;
        }
        assert.equal(reverted, true, "Access not blocked for requireIsOperational");

        // Set it back for other tests to work
        await config.flightSuretyData.resumeContract();

    });

    it('(airline) cannot register an Airline using registerAirline() if it is not funded', async () => {

        // ARRANGE
        let newAirline = accounts[2];

        let reverted = false;

        // ACT
        try {
            await config.flightSuretyApp.registerAirline(newAirline, {from: config.firstAirline});
        } catch (e) {
            reverted = true;
        }

        //let result = await config.flightSuretyData.isAirline.call(newAirline);

        // ASSERT
        assert.equal(reverted, true, "Airline should not be able to register another airline if it hasn't provided funding");

    });

});
