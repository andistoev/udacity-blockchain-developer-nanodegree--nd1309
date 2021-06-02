import FlightSuretyApp from '../../build/contracts/FlightSuretyApp.json';
import Config from './config.json';
import Web3 from 'web3';
import express from 'express';

// === GLOBAL VARIABLES ===

let config = Config['localhost'];
let web3 = new Web3(new Web3.providers.WebsocketProvider(config.url.replace('http', 'ws')));

let accounts = await web3.eth.getAccounts();

web3.eth.defaultAccount = accounts[0];
console.log(`Default account = ${web3.eth.defaultAccount}`);

let flightSuretyApp = new web3.eth.Contract(FlightSuretyApp.abi, config.appAddress);

await registerEventListeners();

const FIRST_ORACLE_ACCOUNT_IDX = 20;
const ORACLES_COUNT = 30;

registerOracles();

// === APP ===

const app = express();
app.get('/api', (req, res) => {
    res.send({
        message: 'An API for use with your Dapp v3!'
    })
});

export default app;

// === PRIVATE METHODS ===

function registerOracles() {
    let oneEther = web3.utils.toWei("1", "ether");
    console.log(`Register oracles paying ${oneEther} ...`);

    for (let i = 0; i < ORACLES_COUNT; i++) {
        let oracleAddress = accounts[FIRST_ORACLE_ACCOUNT_IDX + i];
        console.log(`${i + 1}. Register oracle ${oracleAddress}`);
        flightSuretyApp.methods.registerOracle().send({value: oneEther, from: oracleAddress, gas: 3000000});
    }
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


