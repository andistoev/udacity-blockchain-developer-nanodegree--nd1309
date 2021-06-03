const FlightSuretyApp = artifacts.require("FlightSuretyApp");
const FlightSuretyData = artifacts.require("FlightSuretyData");
const fs = require('fs');

module.exports = async function (deployer) {

    // GLOBAL VARIABLES

    const firstAirlineAddress = '0xf17f52151EbEF6C7334FAD080c5704D77216b732';

    const flights = [
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02689",
            departureTime: Math.floor(new Date("02 Aug 2021 15:00:00") / 1000),
            origin: "MXP",
            destination: "IBZ"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "U202288",
            departureTime: Math.floor(new Date("02 Aug 2021 16:15:00") / 1000),
            origin: "MXP",
            destination: "LTN"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02835",
            departureTime: Math.floor(new Date("02 Aug 2021 19:40:00") / 1000),
            origin: "MXP",
            destination: "BRI"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02689",
            departureTime: Math.floor(new Date("03 Aug 2021 15:00:00") / 1000),
            origin: "MXP",
            destination: "IBZ"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "U202288",
            departureTime: Math.floor(new Date("03 Aug 2021 16:15:00") / 1000),
            origin: "MXP",
            destination: "LTN"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02835",
            departureTime: Math.floor(new Date("03 Aug 2021 19:40:00") / 1000),
            origin: "MXP",
            destination: "BRI"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02689",
            departureTime: Math.floor(new Date("04 Aug 2021 15:00:00") / 1000),
            origin: "MXP",
            destination: "IBZ"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "U202288",
            departureTime: Math.floor(new Date("04 Aug 2021 16:15:00") / 1000),
            origin: "MXP",
            destination: "LTN"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02835",
            departureTime: Math.floor(new Date("04 Aug 2021 19:40:00") / 1000),
            origin: "MXP",
            destination: "BRI"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02689",
            departureTime: Math.floor(new Date("05 Aug 2021 15:00:00") / 1000),
            origin: "MXP",
            destination: "IBZ"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "U202288",
            departureTime: Math.floor(new Date("05 Aug 2021 16:15:00") / 1000),
            origin: "MXP",
            destination: "LTN"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02835",
            departureTime: Math.floor(new Date("05 Aug 2021 19:40:00") / 1000),
            origin: "MXP",
            destination: "BRI"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02689",
            departureTime: Math.floor(new Date("06 Aug 2021 15:00:00") / 1000),
            origin: "MXP",
            destination: "IBZ"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "U202288",
            departureTime: Math.floor(new Date("06 Aug 2021 16:15:00") / 1000),
            origin: "MXP",
            destination: "LTN"
        },
        {
            airlineAddress: firstAirlineAddress,
            flightNumber: "EC02835",
            departureTime: Math.floor(new Date("06 Aug 2021 19:40:00") / 1000),
            origin: "MXP",
            destination: "BRI"
        }
    ];

    // CONTRACT DEPLOYMENT

    console.log("Start contract migration & setup ...")

    await deployContracts();

    console.log("- obtain instance to them ...");
    let dataContract = await FlightSuretyData.deployed();
    let appContract = await FlightSuretyApp.deployed();

    // CONTRACT INITIALIZATION

    await buildTrustBetweenContracts();

    await registerTheFirstAirline();
    await fundTheFirstAirline();

    for (let idx = 0; idx < flights.length; idx++) {
        await registerFlight(flights[idx]);
    }

    // CONFIG DISTRIBUTION

    publishConfigJsonFiles();

    // ===
    // Functions
    // ===

    async function deployContracts() {
        console.log("- deploy contracts ...");
        await deployer.deploy(FlightSuretyData);
        await deployer.deploy(FlightSuretyApp, FlightSuretyData.address);
    }

    async function buildTrustBetweenContracts() {
        console.log("- build trust between contracts ...");
        await dataContract.authorizeContractCaller(FlightSuretyApp.address);
    }

    async function registerTheFirstAirline() {
        console.log("- register the first airline ...");
        await appContract.registerTheFirstAirline(firstAirlineAddress, "easyJet");
    }

    async function fundTheFirstAirline() {
        console.log("- fund the first airline ...");
        let insurerFee = await dataContract.getInsurerFee.call();
        await appContract.payAirlineInsurerFee({value: insurerFee, from: firstAirlineAddress});
    }

    async function registerFlight(flight) {
        console.log(`- register flight ${flight.flightNumber} at ${flight.departureTime} from ${flight.origin} to ${flight.destination} ...`);
        await appContract.registerFlight(
            flight.flightNumber,
            flight.departureTime,
            flight.origin,
            flight.destination,
            {from: firstAirlineAddress}
        );
    }

    function publishConfigJsonFiles() {
        console.log("- publish config json files ...");
        let config = {
            localhost: {
                url: 'http://localhost:8545',
                dataAddress: FlightSuretyData.address,
                appAddress: FlightSuretyApp.address,
                firstAirlineAddress: firstAirlineAddress,
                flights: flights
            }
        }
        fs.writeFileSync(__dirname + '/../src/dapp/config.json', JSON.stringify(config, null, '\t'), 'utf-8');
        fs.writeFileSync(__dirname + '/../src/server/config.json', JSON.stringify(config, null, '\t'), 'utf-8');
    }
}
