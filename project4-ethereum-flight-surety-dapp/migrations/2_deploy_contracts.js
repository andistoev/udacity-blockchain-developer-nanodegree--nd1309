const FlightSuretyApp = artifacts.require("FlightSuretyApp");
const FlightSuretyData = artifacts.require("FlightSuretyData");
const fs = require('fs');

module.exports = async function (deployer) {

    let firstAirlineAddress = '0xf17f52151EbEF6C7334FAD080c5704D77216b732';
    await deployAndInitContracts();

    async function deployAndInitContracts() {
        console.log("Set up contracts ...");
        await deployContracts()
        await registerTheFirstAirline();
        publishConfigJsonFiles();
    }

    async function deployContracts() {
        await deployer.deploy(FlightSuretyData);
        await deployer.deploy(FlightSuretyApp, FlightSuretyData.address);
    }

    async function registerTheFirstAirline() {
        console.log(`- register the first airline <address: ${firstAirlineAddress}> ...`);

        /*
        // https://ethereum.stackexchange.com/questions/67487/solidity-truffle-call-contract-function-in-migration-file

        let flightSuretyData = await FlightSuretyData.new();
        let flightSuretyApp = await FlightSuretyApp.new(flightSuretyData.address);

        await flightSuretyData.authorizeContractCaller(FlightSuretyApp.address);
        await flightSuretyApp.registerTheFirstAirline(firstAirlineAddress, "First Airline");

         */
    }

    function publishConfigJsonFiles() {
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

}
