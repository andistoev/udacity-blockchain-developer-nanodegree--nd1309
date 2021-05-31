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
        FULLY_QUALIFIED: 2
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
            // given
            let secondAirline = accounts[2];

            // when
            // then
            await truffleAssert.reverts(
                appContract.registerAirline(secondAirline, {from: config.firstAirline}),
                "Caller is not a fully qualified insurer"
            );
        });

        it('the first airline can pay airline fee and can become fully-qualified insurer', async () => {
            // given
            let insurerFee = await getInsurerFee();

            eventCapture.clear();

            // when
            await appContract.payAirlineInsurerFee({value: insurerFee, from: config.firstAirline});

            // then
            assert.equal(eventCapture.events.length, 1);
            eventCapture.assertInsurerStateChanged(0, eventType.InsurerStateChanged, config.firstAirline, InsurerState.FULLY_QUALIFIED);
        });

        it('can register a second airline using registerAirline() after the registering airline is funded', async () => {
            // given
            let secondAirline = accounts[2];

            let insurerFee = await dataContract.getInsurerFee();

            eventCapture.clear();

            // when
            await appContract.registerAirline(secondAirline, "second airline", {from: config.firstAirline});

            // then
            assert.equal(eventCapture.events.length, 1);
            eventCapture.assertInsurerStateChanged(0, eventType.InsurerStateChanged, secondAirline, InsurerState.REGISTERED);
        });

        it('the second airline can pay airline fee and can become fully-qualified insurer', async () => {
            // given
            let insurerFee = await getInsurerFee();

            let secondAirline = accounts[2];

            eventCapture.clear();

            // when
            await appContract.payAirlineInsurerFee({value: insurerFee, from: secondAirline});

            // then
            assert.equal(eventCapture.events.length, 1);
            eventCapture.assertInsurerStateChanged(0, eventType.InsurerStateChanged, secondAirline, InsurerState.FULLY_QUALIFIED);
        });

        it('the third and fourth airline can be registered without multi-parity consensus and therefore they can pay airline fee and can become fully-qualified insurers', async () => {
            // given
            let insurerFee = await getInsurerFee();

            let secondAirline = accounts[2];
            let thirdAirline = accounts[3];
            let fourthAirline = accounts[4];

            eventCapture.clear();

            // when
            await appContract.registerAirline(thirdAirline, "third airline", {from: secondAirline});
            await appContract.payAirlineInsurerFee({value: insurerFee, from: thirdAirline});
            await appContract.registerAirline(fourthAirline, "fourth airline", {from: thirdAirline});
            await appContract.payAirlineInsurerFee({value: insurerFee, from: fourthAirline});

            // then
            assert.equal(eventCapture.events.length, 4);
            eventCapture.assertInsurerStateChanged(0, eventType.InsurerStateChanged, thirdAirline, InsurerState.REGISTERED);
            eventCapture.assertInsurerStateChanged(1, eventType.InsurerStateChanged, thirdAirline, InsurerState.FULLY_QUALIFIED);
            eventCapture.assertInsurerStateChanged(2, eventType.InsurerStateChanged, fourthAirline, InsurerState.REGISTERED);
            eventCapture.assertInsurerStateChanged(3, eventType.InsurerStateChanged, fourthAirline, InsurerState.FULLY_QUALIFIED);
        });

        it('the fifth airline can be registered with multi-parity consensus only', async () => {
            // given
            let insurerFee = await getInsurerFee();

            let thirdAirline = accounts[3];
            let fourthAirline = accounts[4];
            let fifthAirline = accounts[5];

            eventCapture.clear();

            // when
            await appContract.registerAirline(fifthAirline, "fifth airline", {from: thirdAirline});

            // then
            assert.equal(eventCapture.events.length, 0);

            // and when
            await appContract.registerAirline(fifthAirline, "fifth airline", {from: fourthAirline});

            // and then
            assert.equal(eventCapture.events.length, 1);
            eventCapture.assertInsurerStateChanged(0, eventType.InsurerStateChanged, fifthAirline, InsurerState.REGISTERED);
        });

        async function getInsurerFee() {
            let insurerFee = await dataContract.getInsurerFee();
            assert.equal(web3.utils.fromWei(insurerFee, "ether"), '10');
            return insurerFee;
        }


    });

});
