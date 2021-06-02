const FlightSuretyApp = artifacts.require("FlightSuretyApp");
const FlightSuretyData = artifacts.require("FlightSuretyData");
const BigNumber = require('bignumber.js');

const ConfigTests = async function (accounts) {

    // These test addresses are useful when you need to add
    // multiple users in test scripts
    let testAddresses = [
        "0x69e1CB5cFcA8A311586e3406ed0301C06fb839a2",
        "0xF014343BDFFbED8660A9d8721deC985126f189F3",
        "0x0E79EDbD6A727CfeE09A2b1d0A59F7752d5bf7C9",
        "0x9bC1169Ca09555bf2721A5C9eC6D69c8073bfeB4",
        "0xa23eAEf02F9E0338EEcDa8Fdd0A73aDD781b2A86",
        "0x6b85cc8f612d5457d49775439335f83e12b8cfde",
        "0xcbd22ff1ded1423fbc24a7af2148745878800024",
        "0xc257274276a4e539741ca11b590b9447b26a8051",
        "0x2f2899d6d35b1a48a4fbdc93a37a72f264a9fca7"
    ];


    let owner = accounts[0];
    let firstAirline = accounts[1];

    let dataContract = await FlightSuretyData.new();
    let appContract = await FlightSuretyApp.new(dataContract.address);

    await EventCapture.registerEvents(dataContract, appContract);

    await dataContract.authorizeContractCaller(appContract.address);
    await appContract.registerTheFirstAirline(firstAirline, "First Airline");

    return {
        owner: owner,
        firstAirline: firstAirline,
        weiMultiple: (new BigNumber(10)).pow(18),
        testAddresses: testAddresses,
        dataContract: dataContract,
        appContract: appContract,
        eventCapture: EventCapture
    }
}

module.exports = {
    Config: ConfigTests
};

/*
 * Event handlers
 */

const EventType = {
    InsurerStateChanged: "InsurerStateChanged",
    InsurancePolicyStateChanged: "InsurancePolicyStateChanged",
    FundingReceived: "FundingReceived",
    OracleRegistered: "OracleRegistered",
    FlightStatusInfoRequested: "FlightStatusInfoRequested",
    FlightStatusInfoSubmitted: "FlightStatusInfoSubmitted",
    FlightStatusInfoUpdated: "FlightStatusInfoUpdated"
};

const EventCapture = {

    events: [],

    registerEvents: async function (dataContract, appContract) {
        await dataContract.InsurerStateChanged(this.insurerStateChangedHandler);
        await dataContract.InsurancePolicyStateChanged(this.insurancePolicyStateChangedHandler);
        await dataContract.FundingReceived(this.fundingReceivedHandler);

        await appContract.OracleRegistered(this.oracleRegisteredHandler);
        await appContract.FlightStatusInfoRequested(this.flightStatusInfoRequestedHandler);
        await appContract.FlightStatusInfoSubmitted(this.flightStatusInfoSubmittedHandler);
        await appContract.FlightStatusInfoUpdated(this.flightStatusInfoUpdatedHandler);
    },

    clear: function () {
        this.events = [];
    },

    consumeEvent: function (type, resultArgs, msg) {
        console.log(` => Received event ${type} <${msg}>`);

        let event = {type: type, params: resultArgs};
        this.events.push(event);
    },

    insurerStateChangedHandler: function (error, result) {
        let msg = `airlineAddress: ${result.args.insurerAddress}, state: ${result.args.state}`;
        EventCapture.consumeEvent(EventType.InsurerStateChanged, result.args, msg);
    },

    assertInsurerStateChanged: function (eventIdx, exectedInsurerAddress, expectedState) {
        assert.equal(this.events[eventIdx].type, EventType.InsurerStateChanged);
        assert.equal(this.events[eventIdx].params.insurerAddress, exectedInsurerAddress);
        assert.equal(this.events[eventIdx].params.state.toNumber(), expectedState);
    },

    insurancePolicyStateChangedHandler: function (error, result) {
        let msg = `insureeAddress: ${result.args.insureeAddress}, insuredFlightKey: ${result.args.insuredObjectKey}, state: ${result.args.state}`;
        EventCapture.consumeEvent(EventType.InsurancePolicyStateChanged, result.args, msg);
    },

    assertInsurancePolicyStateChanged: function (eventIdx, exectedInsureeAddress, expectedState) {
        assert.equal(this.events[eventIdx].type, EventType.InsurancePolicyStateChanged);
        assert.equal(this.events[eventIdx].params.insureeAddress, exectedInsureeAddress);
        assert.equal(this.events[eventIdx].params.state.toNumber(), expectedState);
    },

    fundingReceivedHandler: function (error, result) {
        let msg = `sponsorAddress: ${result.args.sponsorAddress}, amountPaid: ${result.args.amountPaid}`;
        EventCapture.consumeEvent(EventType.FundingReceived, result.args, msg);
    },

    oracleRegisteredHandler: function (error, result) {
        let msg = `oracle: ${result.args.oracleAddress}`;
        EventCapture.consumeEvent(EventType.OracleRegistered, result.args, msg);
    },

    assertOracleRegistered: function (eventIdx, exectedOracleAddress) {
        assert.equal(this.events[eventIdx].type, EventType.OracleRegistered);
        assert.equal(this.events[eventIdx].params.oracleAddress, exectedOracleAddress);
    },

    flightStatusInfoRequestedHandler: function (error, result) {
        let msg = `index: ${result.args.index.toNumber()}, airlineAddress: ${result.args.airlineAddress}, flightNumber: ${result.args.flightNumber}, departureTime: ${result.args.departureTime.toNumber()}`;
        EventCapture.consumeEvent(EventType.FlightStatusInfoRequested, result.args, msg);
    },

    assertFlightStatusInfoRequested: function (eventIdx, expectedAirlineAddress, expectedFlightNumber, expectedDepartureTime) {
        assert.equal(this.events[eventIdx].type, EventType.FlightStatusInfoRequested);
        assert.equal(this.events[eventIdx].params.airlineAddress, expectedAirlineAddress);
        assert.equal(this.events[eventIdx].params.flightNumber, expectedFlightNumber);
        assert.equal(this.events[eventIdx].params.departureTime, expectedDepartureTime);
    },

    flightStatusInfoSubmittedHandler: function (error, result) {
        let msg = `airlineAddress: ${result.args.airlineAddress}, flightNumber: ${result.args.flightNumber}, departureTime: ${result.args.departureTime.toNumber()}, flightStatus: ${result.args.flightStatus}`;
        EventCapture.consumeEvent(EventType.FlightStatusInfoSubmitted, result.args, msg);
    },

    assertFlightStatusInfoSubmitted: function (eventIdx, expectedAirlineAddress, expectedFlightNumber, expectedDepartureTime, expectedFlightStatus) {
        assert.equal(this.events[eventIdx].type, EventType.FlightStatusInfoSubmitted);
        assert.equal(this.events[eventIdx].params.airlineAddress, expectedAirlineAddress);
        assert.equal(this.events[eventIdx].params.flightNumber, expectedFlightNumber);
        assert.equal(this.events[eventIdx].params.departureTime, expectedDepartureTime);
        assert.equal(this.events[eventIdx].params.flightStatus.toNumber(), expectedFlightStatus);
    },

    flightStatusInfoUpdatedHandler: function (error, result) {
        let msg = `airlineAddress: ${result.args.airlineAddress}, flightNumber: ${result.args.flightNumber}, departureTime: ${result.args.departureTime.toNumber()}, flightStatus: ${result.args.flightStatus}`;
        EventCapture.consumeEvent(EventType.FlightStatusInfoUpdated, result.args, msg);
    },

    assertFlightStatusInfoUpdated: function (eventIdx, expectedAirlineAddress, expectedFlightNumber, expectedDepartureTime, expectedFlightStatus) {
        assert.equal(this.events[eventIdx].type, EventType.FlightStatusInfoUpdated);
        assert.equal(this.events[eventIdx].params.airlineAddress, expectedAirlineAddress);
        assert.equal(this.events[eventIdx].params.flightNumber, expectedFlightNumber);
        assert.equal(this.events[eventIdx].params.departureTime, expectedDepartureTime);
        assert.equal(this.events[eventIdx].params.flightStatus.toNumber(), expectedFlightStatus);
    },
}



