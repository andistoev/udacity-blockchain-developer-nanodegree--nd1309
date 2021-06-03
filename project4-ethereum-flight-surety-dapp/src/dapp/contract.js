import FlightSuretyApp from '../../build/contracts/FlightSuretyApp.json';
import Config from './config.json';
import Web3 from 'web3';
import moment from 'moment';

export default class Contract {
    constructor(network, callback) {

        let config = Config[network];

        this.web3 = new Web3(new Web3.providers.WebsocketProvider(config.url.replace('http', 'ws')));
        this.appContract = new this.web3.eth.Contract(FlightSuretyApp.abi, config.appAddress);
        this.initialize(callback);
        this.firstAirlineAddress = config.firstAirlineAddress;
        this.passengerAddress = null;
        this.flights = config.flights;

        this.ONE_ETHER = this.web3.utils.toWei("1", "ether");

        this.hFlightStatusCodeDescription = {
            '0': 'STATUS_CODE_UNKNOWN (0) => Sorry! Credit withdraw NOT authorized!',
            '10': 'STATUS_CODE_ON_TIME (10) => Sorry! Credit withdraw NOT authorized!',
            '20': 'STATUS_CODE_LATE_AIRLINE (20) => YEAH! Credit withdraw authorized!',
            '30': 'STATUS_CODE_LATE_WEATHER (30) => Sorry! Credit withdraw NOT authorized!',
            '40': 'STATUS_CODE_LATE_TECHNICAL (40) => Sorry! Credit withdraw NOT authorized!',
            '50': 'STATUS_CODE_LATE_OTHER (50) => Sorry! Credit withdraw NOT authorize!'
        };
    }

    initialize(callback) {
        let self = this;
        this.web3.eth.getAccounts((error, accts) => {

            console.log(`Retrieved accounts: <0: ${accts[0]}, 1: ${accts[1]}, 2: ${accts[2]}, firstAirlineAddress: ${self.firstAirlineAddress}> ...`);

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

        self.appContract.methods
            .isContractOperational()
            .call({from: self.passengerAddress}, callback);
    }

    getFlightStatusInfo(flightNumber, flightDepartureTime, status) {
        return `Flight <${flightDepartureTime} | ${flightNumber}> has ${this.hFlightStatusCodeDescription[status]}`;
    }

    getFlightDescriptionByIdx(flightIdx) {
        if (!Number.isInteger(flightIdx) || flightIdx < 0 || flightIdx > this.flights.length - 1) {
            throw new Error("Invalid flight requested");
        }

        let flight = this.flights[flightIdx];
        let flightDepartureTime = moment(flight.departureTime * 1000).format("Do MMM HH:mm");
        return `${flightDepartureTime} | ${flight.origin} -> ${flight.destination} | ${flight.flightNumber}`;
    }

    getUserBalance(callback) {
        let self = this;
        let balance = this.web3.eth.getBalance(this.passengerAddress, function (error, result) {
            if (error) {
                console.log(error);
                callback(error, null);
                return;
            }

            let balanceInWei = result;
            let balanceInEth = self.web3.utils.fromWei(balanceInWei, 'ether');

            callback(error, balanceInEth);
        });
    }

    buyFlightInsurance(flightIdx, callback) {
        let self = this;

        let flight = self.flights[parseInt(flightIdx)];

        console.log(`Buy flight insurance for flight = <${self.getFlightDescriptionByIdx(parseInt(flightIdx))}> from address=${self.passengerAddress} paying ${self.ONE_ETHER} wei`);

        self.appContract.methods
            .buyFlightInsurance(flight.airlineAddress, flight.flightNumber, flight.departureTime)
            .send({from: self.passengerAddress, value: self.ONE_ETHER, gas: 3000000}, (error, result) => {
                if (error) {
                    console.error(error);
                }
                callback(error, flight);
            });
    }

    requestFlightStatusInfo(flightIdx, callback) {
        let self = this;

        let flight = self.flights[parseInt(flightIdx)];

        console.log(`Request flight status info for flight = <${self.getFlightDescriptionByIdx(parseInt(flightIdx))}> from address=${self.passengerAddress}`);

        self.appContract.methods
            .requestFlightStatusInfo(flight.airlineAddress, flight.flightNumber, flight.departureTime)
            .send({from: self.passengerAddress}, (error, result) => {
                callback(error, flight);
            });
    }

    withdrawFlightInsuranceCredit(flightIdx, callback) {
        let self = this;

        let flight = self.flights[parseInt(flightIdx)];

        console.log(`Withdraw flight insurance credit for flight = <${self.getFlightDescriptionByIdx(parseInt(flightIdx))}> from address=${self.passengerAddress}`);

        self.appContract.methods
            .withdrawFlightInsuranceCredit(flight.airlineAddress, flight.flightNumber, flight.departureTime)
            .send({from: self.passengerAddress}, (error, result) => {
                if (error) {
                    console.error(error);
                }
                callback(error, flight);
            });
    }

    subscribeToFlightStatusInfoUpdatedEvent(callback) {
        console.log("Subscribe to FlightStatusInfoUpdatedEvent ...");
        this.appContract.events.FlightStatusInfoUpdated(callback);
    }
}
