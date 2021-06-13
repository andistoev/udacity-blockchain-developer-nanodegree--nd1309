const SquareVerifier = artifacts.require('SquareVerifier');
const SolnSquareVerifier = artifacts.require('SolnSquareVerifier');
const genuineProofJson = require('../zokrates/proof.json');

contract('SolnSquareVerifier', async (accounts) => {

    let solnSquareVerifierContract;

    const owner = accounts[0];

    const playerOne = accounts[1];

    const tokenIds = [5];

    before('setup contract', async () => {
        const squareVerifierContract = await SquareVerifier.new();
        solnSquareVerifierContract = await SolnSquareVerifier.new(squareVerifierContract.address);
    });

    describe('can add solution and mint verifiable token', function () {

        it('can add solution', async () => {
            // given
            // when
            await solnSquareVerifierContract.registerSolution(
                tokenIds[0], genuineProofJson.inputs,
                genuineProofJson.proof.a, genuineProofJson.proof.b, genuineProofJson.proof.c
            );

            // then
            const totalSupply = await solnSquareVerifierContract.getTotalSupply.call();
            assert.equal(totalSupply, 0);
        });

        it('can mint token', async () => {
            // given
            // when
            await solnSquareVerifierContract.mintPrivacyAssuredRealEstateOwnershipToken(
                playerOne,
                tokenIds[0],
                genuineProofJson.inputs, {from: owner}
            );

            // then
            const totalSupply = await solnSquareVerifierContract.getTotalSupply.call();
            assert.equal(totalSupply, tokenIds.length);
        });
    });

})
