import DOM from './dom';
import Contract from './contract';
import './flightsurety.css';


(async () => {

    let result = null;

    let contract = new Contract('localhost', () => {

        // Read transaction
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

        // User-submitted transaction
        DOM.elid('submit-oracle').addEventListener('click', () => {
            let flightIdx = parseInt(DOM.elid('flight-selection').value);

            contract.requestFlightStatusInfo(flightIdx, (error, flight) => {
                showResults('Oracles', 'Trigger oracles', [{
                    label: 'Fetch Flight Status Info',
                    error: error,
                    value: contract.getFlightInfo(flightIdx)
                }]);
            });
        })

    });


})();

function renderFlightComboboxSelection(contract) {
    let flightSelectionDiv = DOM.elid("flight-selection");

    for (let idx = 0; idx < contract.flights.length; idx++) {
        flightSelectionDiv.appendChild(DOM.option({'value': "" + idx}, contract.getFlightInfo(idx)));
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
