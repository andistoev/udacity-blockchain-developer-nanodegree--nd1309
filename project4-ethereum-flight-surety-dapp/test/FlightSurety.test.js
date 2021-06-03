const truffleAssert = require('truffle-assertions');
const ConfigTests = require('./config/configTests.js');
const BigNumber = require('bignumber.js');

contract('Flight Surety Tests', async (accounts) => {

    let config;

    let appContract;
    let dataContract;

    let eventCapture;

    before('setup contract', async () => {
        config = await ConfigTests.Config(accounts);

        appContract = config.appContract;
        dataContract = config.dataContract;
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
            let status = await appContract.isContractOperational.call();
            assert.equal(status, expectedStatus, "Incorrected operational status");
        }
    });

    /***********************************************************************************/
    /* Insurer Registration                                                            */
    /***********************************************************************************/

    describe('Test Insurer Registration', function () {

        const InsurerState = {
            UNREGISTERED: 0,
            REGISTERED: 1,
            FULLY_QUALIFIED: 2
        };

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
            eventCapture.assertInsurerStateChanged(0, config.firstAirline, InsurerState.FULLY_QUALIFIED);
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
            eventCapture.assertInsurerStateChanged(0, secondAirline, InsurerState.REGISTERED);
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
            eventCapture.assertInsurerStateChanged(0, secondAirline, InsurerState.FULLY_QUALIFIED);
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
            eventCapture.assertInsurerStateChanged(0, thirdAirline, InsurerState.REGISTERED);
            eventCapture.assertInsurerStateChanged(1, thirdAirline, InsurerState.FULLY_QUALIFIED);
            eventCapture.assertInsurerStateChanged(2, fourthAirline, InsurerState.REGISTERED);
            eventCapture.assertInsurerStateChanged(3, fourthAirline, InsurerState.FULLY_QUALIFIED);
        });

        it('the fifth airline can be registered with multi-parity consensus only', async () => {
            // given
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
            eventCapture.assertInsurerStateChanged(0, fifthAirline, InsurerState.REGISTERED);
        });

        it('the fifth airline can not participate in the contract because is not yet fully qualified (have not yet paied the fee)', async () => {
            // given
            let insurerFee = await getInsurerFee();

            let fifthAirline = accounts[5];
            let sixthAirline = accounts[6];

            eventCapture.clear();

            // when
            await truffleAssert.reverts(
                appContract.registerAirline(sixthAirline, "sixth airline", {from: fifthAirline}),
                "Caller is not a fully qualified insurer"
            );

            // then
            assert.equal(eventCapture.events.length, 0);
        });

        async function getInsurerFee() {
            let insurerFee = await dataContract.getInsurerFee.call();
            assert.equal(web3.utils.fromWei(insurerFee, "ether"), '10');
            return insurerFee;
        }
    });

    /***********************************************************************************/
    /* Insurance Lifecycle & Oracle Iteraction                                         */
    /***********************************************************************************/

    describe('Test Insurance Lifecycle & Oracle Iteraction', function () {

        let flight1 = {
            airlineIdx: 1,
            flightNumber: "BA2490",
            departureTime: Math.floor(new Date("15 Jul 2021 10:00:00 GMT") / 1000),
            origin: "ZRH",
            destination: "MXP"
        };

        const InsurancePolicyState = {
            AVAILABLE: 0,
            ACQUIRED: 1,
            CLOSED_NO_MONEY_BACK: 2,
            CREDIT_APPROVED: 3,
            CREDIT_WITHDRAWN: 4
        };

        const FlightStatusCode = {
            STATUS_CODE_UNKNOWN: 0,
            STATUS_CODE_ON_TIME: 10,
            STATUS_CODE_LATE_AIRLINE: 20,
            STATUS_CODE_LATE_WEATHER: 30,
            STATUS_CODE_LATE_TECHNICAL: 40,
            STATUS_CODE_LATE_OTHER: 50
        };

        const FIRST_ORACLE_ACCOUNT_IDX = 20;
        const ORACLES_COUNT = 30;

        it('a flight can be registered', async () => {
            // given
            let airlineAddress = accounts[flight1.airlineIdx];

            // when
            await appContract.registerFlight(
                flight1.flightNumber,
                flight1.departureTime,
                flight1.origin,
                flight1.destination,
                {from: airlineAddress}
            );
        });

        it('passengers can not pay more then 1 ether for purchasing flight insurance', async () => {
            // given
            let airlineAddress = accounts[flight1.airlineIdx];
            let passengerAddress = accounts[10];

            // when
            // then
            await truffleAssert.reverts(
                appContract.buyFlightInsurance(
                    airlineAddress,
                    flight1.flightNumber,
                    flight1.departureTime,
                    {value: web3.utils.toWei("1", "ether") + 1, from: passengerAddress}
                ),
                "Invalid insurance price paid"
            );
        });

        it('passengers can buy flight insurance for 1 ether', async () => {
            // given
            let airlineAddress = accounts[flight1.airlineIdx];
            let passengerAddress = accounts[10];

            eventCapture.clear();

            // when
            await appContract.buyFlightInsurance(
                airlineAddress,
                flight1.flightNumber,
                flight1.departureTime,
                {value: web3.utils.toWei("1", "ether"), from: passengerAddress}
            );

            // then
            assert.equal(eventCapture.events.length, 1);
            eventCapture.assertInsurancePolicyStateChanged(0, passengerAddress, InsurancePolicyState.ACQUIRED);
        });

        it('can register all oracles and persist them in memory', async () => {
            // given
            let oneEther = web3.utils.toWei("1", "ether");

            eventCapture.clear();

            // when
            for (let i = 0; i < ORACLES_COUNT; i++) {
                await appContract.registerOracle({value: oneEther, from: accounts[FIRST_ORACLE_ACCOUNT_IDX + i]});
            }

            // then
            assert.equal(eventCapture.events.length, ORACLES_COUNT);
            for (let i = 0; i < ORACLES_COUNT; i++) {
                eventCapture.assertOracleRegistered(i, accounts[FIRST_ORACLE_ACCOUNT_IDX + i]);
            }
        });

        it('can request flight status info from oracles', async () => {
            // given
            let airlineAddress = accounts[flight1.airlineIdx];

            eventCapture.clear();

            // when
            await appContract.requestFlightStatusInfo(airlineAddress, flight1.flightNumber, flight1.departureTime);

            // then
            assert.equal(eventCapture.events.length, 1);
            eventCapture.assertFlightStatusInfoRequested(0, airlineAddress, flight1.flightNumber, flight1.departureTime);
        });

        it('oracles can submit flight status info for airline fault matching with the requestedIndex', async () => {
            // given
            let requestedIndex = eventCapture.events[0].params.index.toNumber();
            console.log(`=> Retrieved from the last event the requestedIndex = ${requestedIndex}`);

            let airlineAddress = accounts[flight1.airlineIdx];

            let passengerAddress = accounts[10];

            eventCapture.clear();

            let acceptedSubmitsCtr = 0;
            let oracleResponsesRequiredForValidation = (await appContract.ORACLE_RESPONSES_REQUIRED_FOR_VALIDATION.call()).toNumber();
            assert(oracleResponsesRequiredForValidation, 3);

            // when
            for (let i = 0; i < ORACLES_COUNT; i++) {
                let oracleAddress = accounts[FIRST_ORACLE_ACCOUNT_IDX + i];
                let oracleIndexes = await appContract.getMyIndexes.call({from: oracleAddress});

                for (let idx = 0; idx < 3; idx++) {
                    if (oracleIndexes[idx] != requestedIndex) {
                        continue;
                    }

                    console.log(`Submitting from oracle ${oracleAddress}`);

                    await appContract.submitFlightStatusInfo(
                        requestedIndex,
                        airlineAddress,
                        flight1.flightNumber,
                        flight1.departureTime,
                        FlightStatusCode.STATUS_CODE_LATE_AIRLINE,
                        {from: oracleAddress}
                    );

                    acceptedSubmitsCtr++;

                    if (acceptedSubmitsCtr == oracleResponsesRequiredForValidation) {
                        break;
                    }
                }

                if (acceptedSubmitsCtr == oracleResponsesRequiredForValidation) {
                    break;
                }
            }

            // then
            assert.equal(eventCapture.events.length, 5);

            eventCapture.assertFlightStatusInfoSubmitted(0, airlineAddress, flight1.flightNumber, flight1.departureTime, FlightStatusCode.STATUS_CODE_LATE_AIRLINE);
            eventCapture.assertFlightStatusInfoSubmitted(1, airlineAddress, flight1.flightNumber, flight1.departureTime, FlightStatusCode.STATUS_CODE_LATE_AIRLINE);
            eventCapture.assertInsurancePolicyStateChanged(2, passengerAddress, InsurancePolicyState.CREDIT_APPROVED);
            eventCapture.assertFlightStatusInfoSubmitted(3, airlineAddress, flight1.flightNumber, flight1.departureTime, FlightStatusCode.STATUS_CODE_LATE_AIRLINE);
            eventCapture.assertFlightStatusInfoUpdated(4, airlineAddress, flight1.flightNumber, flight1.departureTime, FlightStatusCode.STATUS_CODE_LATE_AIRLINE);
        });

        it('passengers can withdraw any funds owed to them as a result of receiving credit for insurance payout', async () => {
            // given
            let airlineAddress = accounts[flight1.airlineIdx];
            let passengerAddress = accounts[10];

            let initialBalanceInWei = await getBalanceInWei(passengerAddress);

            eventCapture.clear();

            // when
            txResult = await appContract.withdrawFlightInsuranceCredit(
                airlineAddress,
                flight1.flightNumber,
                flight1.departureTime,
                {from: passengerAddress}
            );

            // then
            assert.equal(eventCapture.events.length, 1);
            eventCapture.assertInsurancePolicyStateChanged(0, passengerAddress, InsurancePolicyState.CREDIT_WITHDRAWN);

            let transactionCostInWei = await getTransactionCostInWei(txResult);
            let oneAndHalfEtherInWei = toWei('1.5');
            let expectedFinalBalanceInWei = initialBalanceInWei.plus(oneAndHalfEtherInWei).minus(transactionCostInWei);

            let finalBalanceInWei = await getBalanceInWei(passengerAddress);

            console.log(`initialBalanceInWei = ${initialBalanceInWei}, finalBalanceInWei = ${finalBalanceInWei}, transactionCostInWei = ${transactionCostInWei}`);

            assert.equal(finalBalanceInWei.toString(), expectedFinalBalanceInWei.toString());
        });

        async function getBalanceInWei(address) {
            let balance = await web3.eth.getBalance(address);
            return new BigNumber(balance);
        }

        function getGasUsed(txResult) {
            return txResult.receipt.gasUsed;
        }

        async function getGasPrice(txResult) {
            let tx = await web3.eth.getTransaction(txResult.tx);
            return tx.gasPrice;
        }

        async function getTransactionCostInWei(txResult) {
            let gasUsed = getGasUsed(txResult);
            let gasPrice = await getGasPrice(txResult);
            console.log(` => gasUsed = ${gasUsed}, gasPrice = ${gasPrice}`);

            let getTransactionCostInWei = new BigNumber(gasPrice).multipliedBy(new BigNumber(gasUsed));
            console.log(` => getTransactionCostInWei = ${getTransactionCostInWei}`);

            return getTransactionCostInWei;
        }

        function toEther(weiBN) {
            return web3.utils.fromWei(weiBN, "ether");
        }

        function toWei(etherBN) {
            return web3.utils.toWei(etherBN, "ether");
        }

    });

});
