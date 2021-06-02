const FlightSuretyApp = artifacts.require("FlightSuretyApp");
const FlightSuretyData = artifacts.require("FlightSuretyData");
const fs = require('fs');

module.exports = function (deployer) {

    deployer.deploy(FlightSuretyData)
        .then(() => {
            return deployer.deploy(FlightSuretyApp, FlightSuretyData.address)
                .then(() => setupContracts());
        });

    let firstAirlineAddress = '0xf17f52151EbEF6C7334FAD080c5704D77216b732';

    function setupContracts() {
        return new Promise(async (resolve, reject) => {
            try {
                console.log("Set up contracts ...");
                await registerTheFirstAirline();
                publishConfigJsonFiles();
                resolve();
            } catch (error) {
                console.error(error);
                reject(error);
            }
        });
    }

    async function registerTheFirstAirline() {
        console.log(`- register the first airline <address: ${firstAirlineAddress}> ...`);
        //await FlightSuretyData.authorizeContractCaller(FlightSuretyApp.address);
        //await FlightSuretyApp.registerTheFirstAirline(firstAirlineAddress, "First Airline");
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
