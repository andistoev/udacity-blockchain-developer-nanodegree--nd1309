var PrivacyAssuredRealEstateOwnershipToken = artifacts.require('PrivacyAssuredRealEstateOwnershipToken');

contract('TestPrivacyAssuredRealEstateOwnershipToken', async (accounts) => {

    const owner = accounts[0];

    const playerOne = accounts[1];
    const playerTwo = accounts[2];

    const tokenIds = [0, 1, 2, 3];

    let contract;

    describe('match erc721 spec', function () {
        before('setup contract', async () => {
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
            const baseTokenURI = await contract.getBaseTokenURI.call();

            // when
            const tokenURI = await contract.getTokenURI.call(tokenIds[1]);

            // then
            assert.equal(tokenURI, baseTokenURI + tokenIds[1], "Incorrect token URI");
        });

        it('should transfer token from one owner to another', async function () {

        });
    });

    describe('have ownership properties', function () {
        beforeEach(async function () {
            contract = await PrivacyAssuredRealEstateOwnershipToken.new({from: playerOne});
        });

        it('should fail when minting when address is not contract owner', async () => {

        });

        it('should return contract owner', async () => {

        });

    });
})
