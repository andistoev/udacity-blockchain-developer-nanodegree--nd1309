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

    let flightSuretyData = await FlightSuretyData.new();
    let flightSuretyApp = await FlightSuretyApp.new(flightSuretyData.address);

    await EventCapture.registerEvents(flightSuretyData, flightSuretyApp);

    await flightSuretyData.authorizeContractCaller(flightSuretyApp.address);
    await flightSuretyApp.registerTheFirstAirline(firstAirline, "First Airline");

    return {
        owner: owner,
        firstAirline: firstAirline,
        weiMultiple: (new BigNumber(10)).pow(18),
        testAddresses: testAddresses,
        flightSuretyData: flightSuretyData,
        flightSuretyApp: flightSuretyApp,
        eventCapture: EventCapture
    }
}

module.exports = {
    Config: ConfigTests
};

/*
 * Event handlers
 */

const EventCapture = {

    events: [],

    registerEvents: async function (flightSuretyData, flightSuretyApp) {
        await flightSuretyData.InsurerStateChanged(this.insurerStateChangedHandler);
        await flightSuretyData.InsurancePolicyStateChanged(this.insurancePolicyStateChangedHandler);
        await flightSuretyData.FundingReceived(this.fundingReceivedHandler);

        await flightSuretyApp.OracleFlightStatusInfoRequested(this.oracleFlightStatusInfoRequestedHandler);
        await flightSuretyApp.OracleFlightStatusInfoSubmitted(this.oracleFlightStatusInfoSubmittedHandler);
        await flightSuretyApp.FlightStatusInfoUpdated(this.flightStatusInfoUpdatedHandler);
    },

    clear: function () {
        this.events = [];
    },

    addEvent: function (type, resultArgs) {
        let event = {type: type, params: resultArgs};
        this.events.push(event);
    },

    insurerStateChangedHandler: function (error, result) {
        console.log(` => Consumed event InsurerStateChanged <airlineAddress: ${result.args.insurerAddress}, airlineName: ${result.args.insurerAddress}, state: ${result.args.state}>`);
        EventCapture.addEvent("InsurerStateChanged", result.args);
    },

    insurancePolicyStateChangedHandler: function (error, result) {
        console.log(` => Consumed event InsurancePolicyStateChanged <insureeAddress: ${result.args.insureeAddress}, insuredFlightKey: ${result.args.insuredObjectKey}, state: ${result.args.state}>`);
        EventCapture.addEvent("InsurancePolicyStateChanged", result.args);
    },

    fundingReceivedHandler: function (error, result) {
        console.log(` => Consumed event FundingReceived <sponsorAddress: ${result.args.sponsorAddress}, amountPaid: ${result.args.amountPaid}>`);
        EventCapture.addEvent("FundingReceived", result.args);
    },

    oracleFlightStatusInfoRequestedHandler: function (error, result) {
        console.log(` => Consumed event OracleFlightStatusInfoRequested <index: ${result.args.index.toNumber()}, airlineAddress: ${result.args.airlineAddress}, flightNumber: ${result.args.flightNumber}, departureTime: ${result.args.departureTime.toNumber()}>`);
        EventCapture.addEvent("OracleFlightStatusInfoRequested", result.args);
    },

    oracleFlightStatusInfoSubmittedHandler: function (error, result) {
        console.log(` => Consumed event OracleFlightStatusInfoSubmitted <airlineAddress: ${result.args.airlineAddress}, flightNumber: ${result.args.flightNumber}, departureTime: ${result.args.departureTime.toNumber()}, flightStatus: ${result.args.flightStatus}>`);
        EventCapture.addEvent("OracleFlightStatusInfoSubmitted", result.args);
    },

    flightStatusInfoUpdatedHandler: function (error, result) {
        console.log(` => Consumed event FlightStatusInfoUpdated <airlineAddress: ${result.args.airlineAddress}, flightNumber: ${result.args.flightNumber}, departureTime: ${result.args.departureTime.toNumber()}, flightStatus: ${result.args.flightStatus}>`);
        EventCapture.addEvent("FlightStatusInfoUpdated", result.args);
    }
}



