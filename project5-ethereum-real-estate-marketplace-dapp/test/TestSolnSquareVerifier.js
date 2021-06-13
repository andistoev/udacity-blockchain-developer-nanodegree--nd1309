const SquareVerifier = artifacts.require('SquareVerifier');
const SolnSquareVerifier = artifacts.require('SolnSquareVerifier');
const genuineProofJson = require('../zokrates/proof/proof-token5.json');

contract('SolnSquareVerifier', async (accounts) => {

    let solnSquareVerifierContract;

    const owner = accounts[0];

    const playerOne = accounts[1];

    const tokenIds = [5];

    before('setup contract', async () => {
        const squareVerifierContract = await SquareVerifier.new();
        solnSquareVerifierContract = await SolnSquareVerifier.new(squareVerifierContract.address);
    });

    describe('have a functional ownership\'s workflow', function () {

        it('should claim real estate ownership', async () => {
            // given
            // when
            await solnSquareVerifierContract.claimRealEstateOwnership(
                playerOne, tokenIds[0], genuineProofJson.inputs,
                genuineProofJson.proof.a, genuineProofJson.proof.b[0], genuineProofJson.proof.b[1], genuineProofJson.proof.c
            );

            // then
            const totalSupply = await solnSquareVerifierContract.getTotalSupply.call();
            assert.equal(totalSupply, 0);
        });

        it('should mint token for it', async () => {
            // given
            // when
            await solnSquareVerifierContract.mintPrivacyAssuredRealEstateOwnershipToken(
                playerOne, tokenIds[0], genuineProofJson.inputs
            );

            // then
            const totalSupply = await solnSquareVerifierContract.getTotalSupply.call();
            assert.equal(totalSupply, tokenIds.length);
        });
    });

})
