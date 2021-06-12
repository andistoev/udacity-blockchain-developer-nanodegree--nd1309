var SquareVerifier = artifacts.require('SquareVerifier');
var genuineProofJson = require('../zokrates/proof.json');
var fakeProofJson1 = require('../zokrates/fake_proof1.json');
var fakeProofJson2 = require('../zokrates/fake_proof2.json');

contract('SquareVerifier Test', async (accounts) => {

    let verifierContract;

    before('setup contract', async () => {
        verifierContract = await SquareVerifier.new();
    });

    describe('Test SquareVerifier', function () {

        it('can verify genuine proof', async function () {
            await assertProof(genuineProofJson, true);
        });

        it('can recognize fake proof which is not causing exception by contract execution', async function () {
            await assertProof(fakeProofJson1, false);
        });

        it('can recognize fake proof causing exception by contract execution', async function () {
            await assertProof(fakeProofJson2, false);
        });

        async function assertProof(proofJson, expectedIsProofGenuine) {
            let isProofGeniune = false;

            try {
                isProofGeniune = await verifierContract.verifyTx.call(proofJson.proof.a, proofJson.proof.b, proofJson.proof.c, proofJson.inputs);
            } catch (e) {
                console.warn(`Exception found by contract method execution: ${e}`);
            }

            assert.equal(isProofGeniune, expectedIsProofGenuine);
        }
    });

})
