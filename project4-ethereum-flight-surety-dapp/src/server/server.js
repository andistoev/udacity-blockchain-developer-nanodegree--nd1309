import FlightSuretyApp from '../../build/contracts/FlightSuretyApp.json';
import Config from './config.json';
import Web3 from 'web3';
import express from 'express';

// === GLOBAL VARIABLES ===

const FIRST_ORACLE_ACCOUNT_IDX = 20;
const ORACLES_COUNT = 30;

const FlightStatusCode = {
    STATUS_CODE_UNKNOWN: 0,
    STATUS_CODE_ON_TIME: 10,
    STATUS_CODE_LATE_AIRLINE: 20,
    STATUS_CODE_LATE_WEATHER: 30,
    STATUS_CODE_LATE_TECHNICAL: 40,
    STATUS_CODE_LATE_OTHER: 50
};

const flightStatusCodeArr = [
    FlightStatusCode.STATUS_CODE_UNKNOWN,
    FlightStatusCode.STATUS_CODE_ON_TIME,
    FlightStatusCode.STATUS_CODE_LATE_AIRLINE,
    FlightStatusCode.STATUS_CODE_LATE_WEATHER,
    FlightStatusCode.STATUS_CODE_LATE_TECHNICAL,
    FlightStatusCode.STATUS_CODE_LATE_OTHER
];

let hIndexesByOracleAddress = {};

const config = Config['localhost'];
const web3 = new Web3(new Web3.providers.WebsocketProvider(config.url.replace('http', 'ws')));
const ONE_ETHER = web3.utils.toWei("1", "ether");

let accounts = await web3.eth.getAccounts();
web3.eth.defaultAccount = accounts[0];
console.log(`Default account = ${web3.eth.defaultAccount}`);

let flightSuretyApp = new web3.eth.Contract(FlightSuretyApp.abi, config.appAddress);

await registerEventListeners();
registerOracles();

// === PRIVATE METHODS ===

function registerOracles() {
    console.log(`Register oracles paying ${ONE_ETHER} ...`);

    for (let i = 0; i < ORACLES_COUNT; i++) {
        let oracleAddress = accounts[FIRST_ORACLE_ACCOUNT_IDX + i];
        registerOracle(i + 1, oracleAddress);
    }
}

function registerOracle(idx, oracleAddress) {
    console.log(`${idx}. Register oracle ${oracleAddress}`);
    flightSuretyApp.methods
        .registerOracle()
        .send({from: oracleAddress, value: ONE_ETHER, gas: 3000000}, (error, result) => {
            if (error) throw error;
            fetchOracleIndexes(oracleAddress);
        });
}

function fetchOracleIndexes(oracleAddress) {
    flightSuretyApp.methods.getMyIndexes().call({from: oracleAddress}, (error, result) => {
        if (error) throw error;
        hIndexesByOracleAddress[oracleAddress] = result;
        console.log(`=> oracleAddress = ${oracleAddress}, result = ${result}`);
    });
}

function submitFlightStatusInfoFromMatchingOracles(requestedIndex) {
    console.log(`Submit flight status info from matching oracles to requestedIndex=${requestedIndex}`);

    for (let i = 0; i < ORACLES_COUNT; i++) {
        let oracleAddress = accounts[FIRST_ORACLE_ACCOUNT_IDX + i];
        let indexes = hIndexesByOracleAddress[oracleAddress];
        if (indexes.includes(requestedIndex)) {
            submitFlightStatusInfo(oracleAddress);
        }
    }
}

function submitFlightStatusInfo(oracleAddress) {
    let flightStatusCode = generateRandomFlightStatusCode();
    console.log(`- submit flightStatusCode = <${flightStatusCode}> for oracleAddress = ${oracleAddress}`);

}

function generateRandomFlightStatusCode() {
    let idx = getRandomInt(flightStatusCodeArr.length);
    return flightStatusCodeArr[idx];
}

function getRandomInt(max) {
    return Math.floor(Math.random() * max);
}

async function registerEventListeners() {
    await flightSuretyApp.events.OracleRegistered(oracleRegisteredHandler);
    await flightSuretyApp.events.FlightStatusInfoRequested(flightStatusInfoRequestedHandler);
    await flightSuretyApp.events.FlightStatusInfoSubmitted(flightStatusInfoSubmittedHandler);
    await flightSuretyApp.events.FlightStatusInfoUpdated(flightStatusInfoUpdatedHandler);
}

function oracleRegisteredHandler(error, event) {
    if (error) throw error;
    let result = event.returnValues;
    let msg = `oracle: ${result.oracleAddress}`;
    showEvent("OracleRegistered", msg);
}

function flightStatusInfoRequestedHandler(error, event) {
    if (error) throw error;
    let result = event.returnValues;
    let msg = `index: ${result.index}, airlineAddress: ${result.airlineAddress}, flightNumber: ${result.flightNumber}, departureTime: ${result.departureTime}`;
    showEvent("FlightStatusInfoRequested", msg);

    submitFlightStatusInfoFromMatchingOracles(result.index);
}

function flightStatusInfoSubmittedHandler(error, event) {
    if (error) throw error;
    let result = event.returnValues;
    let msg = `airlineAddress: ${result.airlineAddress}, flightNumber: ${result.flightNumber}, departureTime: ${result.departureTime}, flightStatus: ${result.flightStatus}`;
    showEvent("FlightStatusInfoSubmitted", msg);
}

function flightStatusInfoUpdatedHandler(error, event) {
    if (error) throw error;
    let result = event.returnValues;
    let msg = `airlineAddress: ${result.airlineAddress}, flightNumber: ${result.flightNumber}, departureTime: ${result.departureTime}, flightStatus: ${result.flightStatus}`;
    showEvent("FlightStatusInfoUpdated", msg);
}

function showEvent(type, msg) {
    console.log(` => Received event ${type} <${msg}>`);
}

// === APP ===

const app = express();
app.get('/api', (req, res) => {
    res.send({
        message: 'An API for use with your Dapp v3!'
    })
});

export default app;
