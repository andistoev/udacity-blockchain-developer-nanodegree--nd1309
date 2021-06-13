const SquareVerifier = artifacts.require('SquareVerifier');
const genuineProofJson = require('../zokrates/proof/proof-token0.json');
const fakeProofJson1 = require('../zokrates/proof/proof-token0-fake1.json');
const fakeProofJson2 = require('../zokrates/proof/proof-token0-fake2.json');

contract('SquareVerifier Test', async (accounts) => {

    let contract;

    before('setup contract', async () => {
        contract = await SquareVerifier.new();
    });

    describe('can verify proof', function () {

        it('should verify genuine proof', async () => {
            await assertProof(genuineProofJson, true);
        });

        it('should recognize fake proof which is not causing exception by contract execution', async () => {
            await assertProof(fakeProofJson1, false);
        });

        it('should recognize fake proof causing exception by contract execution', async () => {
            await assertProof(fakeProofJson2, false);
        });

        async function assertProof(proofJson, expectedIsProofGenuine) {
            let isProofGeniune = false;

            try {
                isProofGeniune = await contract.verifyTx.call(proofJson.proof.a, proofJson.proof.b, proofJson.proof.c, proofJson.inputs);
            } catch (e) {
                console.warn(`Exception found by contract method execution: ${e}`);
            }

            assert.equal(isProofGeniune, expectedIsProofGenuine);
        }
    });

})
