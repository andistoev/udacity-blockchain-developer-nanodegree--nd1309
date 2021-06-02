const FlightSuretyApp = artifacts.require("FlightSuretyApp");
const FlightSuretyData = artifacts.require("FlightSuretyData");
const fs = require('fs');

module.exports = async function (deployer) {
    console.log("Start contract migration & setup ...")

    console.log("- deploy contracts ...");
    await deployer.deploy(FlightSuretyData);
    await deployer.deploy(FlightSuretyApp, FlightSuretyData.address);

    console.log("- obtaining instance to them ...");
    let dataContract = await FlightSuretyData.deployed();
    let appContract = await FlightSuretyApp.deployed();

    console.log("- building trust between contracts ...");
    await dataContract.authorizeContractCaller(FlightSuretyApp.address);

    console.log("- register the first airline ...");
    let firstAirlineAddress = '0xf17f52151EbEF6C7334FAD080c5704D77216b732';
    await appContract.registerTheFirstAirline(firstAirlineAddress, "First Airline");

    console.log("- publish config json files ...");
    let config = {
        localhost: {
            url: 'http://localhost:8545',
            dataAddress: FlightSuretyData.address,
            appAddress: FlightSuretyApp.address
        }
    }
    fs.writeFileSync(__dirname + '/../src/dapp/config.json', JSON.stringify(config, null, '\t'), 'utf-8');
    fs.writeFileSync(__dirname + '/../src/server/config.json', JSON.stringify(config, null, '\t'), 'utf-8');
}
