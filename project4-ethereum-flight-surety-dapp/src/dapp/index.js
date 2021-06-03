import DOM from './dom';
import Contract from './contract';
import './flightsurety.css';


(async () => {

    let result = null;

    let contract = new Contract('localhost', () => {

        contract.isContractOperational((error, result) => {
            if (error) {
                throw error;
            }

            console.log(`isContractOperational.result=${result}`);
            showResults('Operational Status', 'Check if contract is operational', [{
                label: 'Operational Status',
                error: error,
                value: result
            }]);
        });

        renderFlightComboboxSelection(contract);

        // BUY INSURANCE
        DOM.elid('buy-insurance').addEventListener('click', () => {
            let flightIdx = parseInt(DOM.elid('flight-selection').value);

            contract.buyFlightInsurance(flightIdx, (error, result) => {
                showResults('Flight insurance', 'Buy flight insurance for 1 eth', [{
                    label: 'Status',
                    error: error,
                    value: `Flight insurance for <${contract.getFlightDescriptionByIdx(flightIdx)}> successfully purchased!`
                }]);
            });
        });

        // SUBMIT TO ORACLE
        DOM.elid('submit-oracle').addEventListener('click', () => {
            let flightIdx = parseInt(DOM.elid('flight-selection').value);

            contract.requestFlightStatusInfo(flightIdx, (error, flight) => {
                showResults('Oracles', 'Trigger oracles', [{
                    label: 'Fetch Flight Status Info',
                    error: error,
                    value: contract.getFlightDescriptionByIdx(flightIdx)
                }]);
            });
        });

        // WITHDRAW CREDIT
        DOM.elid('withdraw-credit').addEventListener('click', () => {
            let flightIdx = parseInt(DOM.elid('flight-selection').value);

            contract.withdrawFlightInsuranceCredit(flightIdx, (error, result) => {
                showResults('Flight insurance', 'Withdraw flight insurance credit', [{
                    label: 'Status',
                    error: error,
                    value: `Flight insurance credit for <${contract.getFlightDescriptionByIdx(flightIdx)}> successfully withdrawn!`
                }]);
            });
        });

        // GET BALANCE
        DOM.elid('get-balance').addEventListener('click', () => {
            contract.getUserBalance((error, result) => {
                showResults('User', `passenger (Account 3: ${contract.passengerAddress})`, [{
                    label: 'Current balance',
                    error: error,
                    value: `${result} ether`
                }]);
            });
        });

        // LISTEN TO ORACLE RESULTS
        contract.subscribeToFlightStatusInfoUpdatedEvent((error, event) => {
            if (error) {
                throw error;
            }

            let result = event.returnValues;
            let msg = `airlineAddress: ${result.airlineAddress}, flightNumber: ${result.flightNumber}, departureTime: ${result.departureTime}, flightStatus: ${result.flightStatus}`;
            console.log(` => Received event FlightStatusInfoUpdated <${msg}>`);

            showResults('Oracles', 'Response from oracles', [{
                label: 'Flight Status Info Updated',
                error: error,
                value: contract.getFlightStatusInfo(result.flightNumber, result.departureTime, result.flightStatus)
            }]);

        });

    });


})();

function renderFlightComboboxSelection(contract) {
    let flightSelectionDiv = DOM.elid("flight-selection");

    for (let idx = 0; idx < contract.flights.length; idx++) {
        flightSelectionDiv.appendChild(DOM.option({'value': "" + idx}, contract.getFlightDescriptionByIdx(idx)));
    }
}

function showResults(title, description, results) {
    let displayDiv = DOM.elid("display-wrapper");
    let section = DOM.section();
    section.appendChild(DOM.h2(title));
    section.appendChild(DOM.h5(description));
    results.map((result) => {
        let row = section.appendChild(DOM.div({className: 'row'}));
        row.appendChild(DOM.div({className: 'col-sm-4 field'}, result.label));
        row.appendChild(DOM.div({className: 'col-sm-8 field-value'}, result.error ? String(result.error) : String(result.value)));
        section.appendChild(row);
    })
    displayDiv.append(section);

}
