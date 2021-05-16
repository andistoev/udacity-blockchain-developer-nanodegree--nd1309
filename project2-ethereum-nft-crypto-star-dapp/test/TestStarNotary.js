const StarNotary = artifacts.require("StarNotary");

let accounts;
let owner;
let user1;
let user2;

let starNotaryContract;

let lastStarId = 0;

contract('StarNotary', (accs) => {
    accounts = accs;
    owner = accounts[0];
    user1 = accounts[1];
    user2 = accounts[2];
});

before(async () => {
    starNotaryContract = await StarNotary.deployed();
});

function createNewStarId(){
    lastStarId++;
    return lastStarId;
}

it('can Create a Star', async() => {
    // given
    const starId = createNewStarId();

    // when
    await starNotaryContract.createStar('Awesome Star!', starId, {from: accounts[0]});

    // then
    assert.equal(await starNotaryContract.tokenIdToStarInfo.call(starId), 'Awesome Star!');
});

it('lets user1 put up their star for sale', async() => {
    // given
    const starId = createNewStarId();
    let starPrice = web3.utils.toWei(".01", "ether");
    await starNotaryContract.createStar('awesome star', starId, {from: user1});

    // when
    await starNotaryContract.putStarUpForSale(starId, starPrice, {from: user1});

    // then
    assert.equal(await starNotaryContract.starsForSale.call(starId), starPrice);
});

it('lets user1 get the funds after the sale', async() => {
    // given
    const starId = createNewStarId();
    let starPrice = web3.utils.toWei(".01", "ether");
    let balance = web3.utils.toWei(".05", "ether");
    await starNotaryContract.createStar('awesome star', starId, {from: user1});
    await starNotaryContract.putStarUpForSale(starId, starPrice, {from: user1});
    let balanceOfUser1BeforeTransaction = await web3.eth.getBalance(user1);

    // when
    await starNotaryContract.buyStar(starId, {from: user2, value: balance});

    // then
    let balanceOfUser1AfterTransaction = await web3.eth.getBalance(user1);
    let value1 = Number(balanceOfUser1BeforeTransaction) + Number(starPrice);
    let value2 = Number(balanceOfUser1AfterTransaction);
    assert.equal(value1, value2);
});

it('lets user2 buy a star, if it is put up for sale', async() => {
    // given
    const starId = createNewStarId();
    let starPrice = web3.utils.toWei(".01", "ether");
    let balance = web3.utils.toWei(".05", "ether");
    await starNotaryContract.createStar('awesome star', starId, {from: user1});
    await starNotaryContract.putStarUpForSale(starId, starPrice, {from: user1});
    let balanceOfUser1BeforeTransaction = await web3.eth.getBalance(user2);

    // when
    await starNotaryContract.buyStar(starId, {from: user2, value: balance});

    // then
    assert.equal(await starNotaryContract.ownerOf.call(starId), user2);
});

it('lets user2 buy a star and decreases its balance in ether', async() => {
    // given
    const starId = createNewStarId();
    let starPrice = web3.utils.toWei(".01", "ether");
    let balance = web3.utils.toWei(".05", "ether");
    await starNotaryContract.createStar('awesome star', starId, {from: user1});
    await starNotaryContract.putStarUpForSale(starId, starPrice, {from: user1});
    let balanceOfUser1BeforeTransaction = await web3.eth.getBalance(user2);
    const balanceOfUser2BeforeTransaction = await web3.eth.getBalance(user2);

    // when
    await starNotaryContract.buyStar(starId, {from: user2, value: balance, gasPrice:0});

    // when
    const balanceAfterUser2BuysStar = await web3.eth.getBalance(user2);
    let value = Number(balanceOfUser2BeforeTransaction) - Number(balanceAfterUser2BuysStar);
    assert.equal(value, starPrice);
});

// Implement Task 2 Add supporting unit tests

it('can add the star name and star symbol properly', async() => {
    // 1. create a Star with different tokenId
    //2. Call the name and symbol properties in your Smart Contract and compare with the name and symbol provided

    // given
    // when
    const starId = createNewStarId();
    await starNotaryContract.createStar('New Star!', starId, {from: accounts[0]});

    // then
    assert.equal(await starNotaryContract.symbol(), 'ACS');
    assert.equal(await starNotaryContract.name(), 'AmazingCryptoStar');
});

it('lookUptokenIdToStarInfo test', async() => {
    // 1. create a Star with different tokenId
    // 2. Call your method lookUptokenIdToStarInfo
    // 3. Verify if you Star name is the same

    // given
    // when
    const starId = createNewStarId();
    await starNotaryContract.createStar('The 7th Star!', starId, {from: accounts[0]})

    // then
    assert.equal(await starNotaryContract.lookUptokenIdToStarInfo(starId), 'The 7th Star!');
});

it('lets 2 users exchange stars', async() => {
    // 1. create 2 Stars with different tokenId
    // 2. Call the exchangeStars functions implemented in the Smart Contract
    // 3. Verify that the owners changed

    // given
    const starId1 = createNewStarId();
    await starNotaryContract.createStar('The 8th Star!', starId1, {from: user1});

    const starId2 = createNewStarId();
    await starNotaryContract.createStar('The 9th Star!', starId2, {from: user2});

    assert.equal(await starNotaryContract.ownerOf.call(starId1), user1);
    assert.equal(await starNotaryContract.ownerOf.call(starId2), user2);

    // when
    await starNotaryContract.exchangeStars(starId1, starId2, {from: user1});

    // then
    assert.equal(await starNotaryContract.ownerOf.call(starId1), user2);
    assert.equal(await starNotaryContract.ownerOf.call(starId2), user1);

});

it('lets a user transfer a star', async() => {
    // 1. create a Star with different tokenId
    // 2. use the transferStar function implemented in the Smart Contract
    // 3. Verify the star owner changed.

    // given
    const starId = createNewStarId();
    await starNotaryContract.createStar('The 10th Star!', starId, {from: user1});

    assert.equal(await starNotaryContract.ownerOf.call(starId), user1);
    assert.notEqual(await starNotaryContract.ownerOf.call(starId), user2);

    // when
    await starNotaryContract.transferStar(user2, starId, {from: user1});

    // then
    assert.notEqual(await starNotaryContract.ownerOf.call(starId), user1);
    assert.equal(await starNotaryContract.ownerOf.call(starId), user2);
});
