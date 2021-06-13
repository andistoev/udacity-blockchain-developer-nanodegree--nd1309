const truffleAssert = require('truffle-assertions');

const PrivacyAssuredRealEstateOwnershipToken = artifacts.require('PrivacyAssuredRealEstateOwnershipToken');

contract('TestPrivacyAssuredRealEstateOwnershipToken', async (accounts) => {

    const owner = accounts[0];

    const playerOne = accounts[1];
    const playerTwo = accounts[2];

    const tokenIds = [0, 1, 2, 3];

    let contract;

    describe('match erc721 spec', function () {

        before(async function () {
            contract = await PrivacyAssuredRealEstateOwnershipToken.new({from: owner});
        });

        it('should mint tokens', async () => {
            for (let i = 0; i < tokenIds.length; i++) {
                const receiver = (i <= 2) ? playerOne : playerTwo;
                await contract.mint(receiver, tokenIds[i], {from: owner});
            }
        });

        it('should return total supply', async () => {
            const result = await contract.getTotalSupply.call();
            assert.equal(result, tokenIds.length);
        });

        it('should get token balance', async () => {
            assert.equal(await contract.balanceOf.call(owner), 0);
            assert.equal(await contract.balanceOf.call(playerOne), 3);
            assert.equal(await contract.balanceOf.call(playerTwo), 1);
        });

        // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
        it('should return token uri', async () => {
            // given
            const baseTokenURI = await contract.baseTokenURI.call();

            // when
            const tokenURI = await contract.tokenURI.call(tokenIds[1]);

            // then
            assert.equal(tokenURI, baseTokenURI + tokenIds[1], "Incorrect token URI");
        });

        it('should transfer token from one owner to another', async function () {
            // given
            let ownerOfTokenId2 = await contract.ownerOf.call(tokenIds[2]);
            assert.equal(ownerOfTokenId2, playerOne, "playerOne is supposed to be the owner here");

            // when
            await contract.transferFrom(playerOne, playerTwo, tokenIds[2], {from: playerOne});

            // then
            ownerOfTokenId2 = await contract.ownerOf.call(tokenIds[2]);

            assert.equal(ownerOfTokenId2, playerTwo, "playerTwo is supposed to be the owner here");
        });

    });

    describe('have ownership properties', function () {

        before(async function () {
            contract = await PrivacyAssuredRealEstateOwnershipToken.new({from: owner});
        });

        it('should fail when minting when address is not contract owner', async () => {
            await truffleAssert.reverts(
                contract.mint(playerTwo, tokenIds[1], {from: playerOne}),
                "Caller is not contract owner"
            );
        });

        it('should return contract owner', async () => {
            // given
            await contract.mint(playerTwo, tokenIds[1], {from: owner});

            // when
            const ownerOfTokenIds1 = await contract.ownerOf.call(tokenIds[1]);

            // then
            assert.equal(ownerOfTokenIds1, playerTwo, "playerTwo is supposed to be the owner");
        });

    });
})
