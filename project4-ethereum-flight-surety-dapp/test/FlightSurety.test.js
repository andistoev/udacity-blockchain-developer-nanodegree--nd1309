const truffleAssert = require('truffle-assertions');

const ConfigTests = require('./config/configTests.js');
const BigNumber = require('bignumber.js');

contract('Flight Surety Tests', async (accounts) => {

    let config;

    let appContract;
    let dataContract;

    let eventType;
    let eventCapture;

    const InsurerState = {
        UNREGISTERED: 0,
        REGISTERED: 1,
        APPROVED: 2,
        FULLY_QUALIFIED: 3
    };

    before('setup contract', async () => {
        config = await ConfigTests.Config(accounts);

        appContract = config.flightSuretyApp;
        dataContract = config.flightSuretyData;

        eventType = config.eventType;
        eventCapture = config.eventCapture;
    });

    /***********************************************************************************/
    /* Operational Status                                                              */
    /***********************************************************************************/

    describe('Test Operational Status', function () {
        it(`has correct initial isContractOperational() value`, async function () {
            await assertIsContractOperational(true);
        });

        it(`can block access to pauseContract() for non-Contract Owner account`, async function () {
            await truffleAssert.reverts(
                dataContract.pauseContract({from: config.testAddresses[2]}),
                "Caller is not contract owner"
            );
            await assertIsContractOperational(true);
        });

        it(`can allow access to pauseContract() and resumeContract() for Contract Owner account`, async function () {
            await dataContract.pauseContract();
            await assertIsContractOperational(false);

            await dataContract.resumeContract();
            await assertIsContractOperational(true);
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
        it('cannot register an airline using registerAirline() if the registering airline is not funded', async () => {
            await truffleAssert.reverts(
                appContract.registerAirline(accounts[2], {from: config.firstAirline}),
                "Caller is not a fully qualified insurer"
            );
        });

        it('the first airline can be funded', async () => {
            // given
            let insurerFee = await dataContract.getInsurerFee();
            assert.equal(web3.utils.fromWei(insurerFee, "ether"), '10');

            eventCapture.clear();

            // when
            await appContract.payAirlineInsurerFee({value: insurerFee, from: config.firstAirline});

            // then
            assert.equal(eventCapture.events.length, 1);
            assert.equal(eventCapture.events[0].type, eventType.InsurerStateChanged);
            assert.equal(eventCapture.events[0].params.state.toNumber(), InsurerState.FULLY_QUALIFIED);
        });

        /*
        it('can register an Airline using registerAirline() after the registering airline is funded', async () => {
            // given
            let insurerFee = await dataContract.getInsurerFee();

            eventCapture.clear();

            // when
            await appContract.registerAirline(accounts[2], {from: config.firstAirline});

            // then
            assert.equal(eventCapture.events.length, 1);
            assert.equal(eventCapture.events[0].type, "InsurerStateChanged");
            assert.equal(eventCapture.events[0].params.state.toNumber(), InsurerState.FULLY_QUALIFIED);
        });

         */
    });

});