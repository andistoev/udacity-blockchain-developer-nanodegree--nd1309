import FlightSuretyApp from '../../build/contracts/FlightSuretyApp.json';
import Config from './config.json';
import Web3 from 'web3';
import moment from 'moment';

export default class Contract {
    constructor(network, callback) {

        let config = Config[network];

        this.web3 = new Web3(new Web3.providers.HttpProvider(config.url));
        this.flightSuretyApp = new this.web3.eth.Contract(FlightSuretyApp.abi, config.appAddress);
        this.initialize(callback);
        this.owner = null;
        this.firstAirlineAddress = config.firstAirlineAddress;
        this.passengerAddress = null;
        this.flights = config.flights;
    }

    initialize(callback) {
        let self = this;
        this.web3.eth.getAccounts((error, accts) => {

            console.log(`Retrieved accounts: <0: ${accts[0]}, 1: ${accts[1]}, 2: ${accts[2]}, firstAirlineAddress: ${self.firstAirlineAddress}> ...`);

            this.owner = accts[0];

            if (accts[1] != self.firstAirlineAddress) {
                throw new Error(`dApp can not be initialized. The account[1] must match the already registered firstAirlineAddress`);
            }

            this.passengerAddress = accts[2];

            callback();
        });
    }

    isContractOperational(callback) {
        let self = this;
        console.log(`Check isContractOperational from address=${self.passengerAddress}`);

        self.flightSuretyApp.methods
            .isContractOperational()
            .call({from: self.passengerAddress}, callback);
    }

    getFlightInfo(flightIdx) {
        if (!Number.isInteger(flightIdx) || flightIdx < 0 || flightIdx > this.flights.length - 1) {
            throw new Error("Invalid flight requested");
        }

        let flight = this.flights[flightIdx];
        let flightDepartureTime = moment(flight.departureTime * 1000).format("Do MMM HH:mm");
        return `${flightDepartureTime} | ${flight.origin} -> ${flight.destination} | ${flight.flightNumber}`;
    }

    requestFlightStatusInfo(flightIdx, callback) {
        let self = this;

        let flight = self.flights[parseInt(flightIdx)];

        console.log(`Request flight status info for flight = <${self.getFlightInfo(parseInt(flightIdx))}> from address=${self.passengerAddress}`);

        self.flightSuretyApp.methods
            .requestFlightStatusInfo(flight.airlineAddress, flight.flightNumber, flight.departureTime)
            .send({from: self.passengerAddress}, (error, result) => {
                callback(error, flight);
            });
    }
}
