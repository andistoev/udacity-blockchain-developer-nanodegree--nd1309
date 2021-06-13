# Ethereum Real Estate Marketplace

Ethereum Real Estate Marketplace is a decentralized marketplace for house property owners.

- Every house property is mint as NFT
- zk-SNARKs proof protects the title's ownership privacy
- A title ownership can be verified through an ethereum solidity contract
- House properties can be traded on a public NFT marketplace OpenSea

This is the 5th capstone project from
the [Udacity - Blockchain Developer Nanodegree Program](https://www.udacity.com/course/blockchain-developer-nanodegree--nd1309)

![pareot reseller](res/pareot-reseller.jpg)

## Structure

The repository contains:

- zokrates: "Genesis" for zk-SNARKs proof and solidity verifier contract
- eth-contracts/contracts: ethereum smart contracts
- eth-contracts/test: Mocha unit testing (executable through Truffle)

## Install

Compatible with:

* Truffle v5.3.7 (core: 5.3.7)
* Solidity v0.8.5 (solc-js)
* OpenZeppelin v4.1.0 (solidity: 0.8.0)
* Node v16.2.0
* Web3.js v1.3.6
* Ganache CLI v6.12.2 (ganache-core: 2.13.2)
* Zokrates v0.7.3

Run:

`npm install`

`truffle compile`

## Develop Back-End

### Testing

Start local ethereum blockchain:

`ganache-cli`

To run all tests:

`npm test` or `truffle test`

To run a single test:

- `truffle test ./test/TestSolnSquareVerifier.js`
- `truffle test ./test/TestERC721Mintable.js`
- `truffle test ./test/TestSquareVerifier.js`

### Deployment on Rinkeby

Create in root folder `.rinkeby-infurakey` and `.secret` and run:

`truffle migrate --network rinkeby`

### Deployment info (required for project submission)

- My first rinkeby account (contract
  owner): [0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89](https://rinkeby.etherscan.io/address/0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89)
- My second rinkeby account (token
  buyer): [0xeEFC23Bd910bb99bEBa0dAe9dA67CB5ED6eDe54d](https://rinkeby.etherscan.io/address/0xeEFC23Bd910bb99bEBa0dAe9dA67CB5ED6eDe54d)
- Contract SquareVerifier
  v4: [0x7c3f2fEe85378bE7bA697505440B43b9BC6fA2c1](https://rinkeby.etherscan.io/address/0x7c3f2fEe85378bE7bA697505440B43b9BC6fA2c1)
- Contract SolnSquareVerifier
  v4: [0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF](https://rinkeby.etherscan.io/address/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF)
- Contract [SolnSquareVerifier ABI](pareot-contract-abi.json)
- Log of deployment to rinkeby: [log](rinkeby-deployment-log.md)

## Develop Front-End

### Token Minting

- Start Brave browser
- Log-in to your [my ether wallet - MEW CX](https://www.myetherwallet.com)
- Change network to Rinkeby Testnet
- Select the contract owner account
- Navigate to [interace with contract](https://www.myetherwallet.com/interface/interact-with-contract)
- Connect to SolnSquareVerifier address and use [this contract abi](pareot-contract-abi.json)
- Mint some tokens

### Token Status at Testnet Open Sea (required for project submission)

- [token0](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/0)
- [token1](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/1)
- [token2](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/2)
- [token3](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/3)
- [token4](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/4)
- [token5](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/5)
- [token6](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/6)
- [token7](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/7)
- [token8](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/8)
- [token9](https://testnets.opensea.io/assets/0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF/9)

### User Interface

![token minting](res/token-minting.png)

![pareot token view](res/pareot-token-view.jpg)

![metamask](res/metamask.png)

## Need to rebuild zokrates?

![zokrates process](res/zokrates-process.png)

```bash
cd zokrates
zokrates compile -i square.code
zokrates setup

# create 10 unique proofs for 10 tokens

zokrates compute-witness -o witness/witness-token0 -a 3 9
zokrates generate-proof -w witness/witness-token0 -j proof/proof-token0.json

zokrates compute-witness -o witness/witness-token1 -a 4 16
zokrates generate-proof -w witness/witness-token1 -j proof/proof-token1.json

zokrates compute-witness -o witness/witness-token2 -a 5 25
zokrates generate-proof -w witness/witness-token2 -j proof/proof-token2.json

zokrates compute-witness -o witness/witness-token3 -a 6 36
zokrates generate-proof -w witness/witness-token3 -j proof/proof-token3.json

zokrates compute-witness -o witness/witness-token4 -a 7 49
zokrates generate-proof -w witness/witness-token4 -j proof/proof-token4.json

zokrates compute-witness -o witness/witness-token5 -a 8 64
zokrates generate-proof -w witness/witness-token5 -j proof/proof-token5.json

zokrates compute-witness -o witness/witness-token6 -a 9 81
zokrates generate-proof -w witness/witness-token6 -j proof/proof-token6.json

zokrates compute-witness -o witness/witness-token7 -a 10 100
zokrates generate-proof -w witness/witness-token7 -j proof/proof-token7.json

zokrates compute-witness -o witness/witness-token8 -a 11 121
zokrates generate-proof -w witness/witness-token8 -j proof/proof-token8.json

zokrates compute-witness -o witness/witness-token9 -a 12 144
zokrates generate-proof -w witness/witness-token9 -j proof/proof-token9.json
```

- Copy 'zokrates/verifier.sol' to 'contracts/SquareVerifier.sol' and upgrade its version to 0.8.5
- Import ISquareVerifier.sol and make sure SquareVerifier implements it
- Copy 'proof/proof-token0.json' as 'proof/proof-token0-fake1.json' and change the inputs to generate fake proof which
  is not causing exception
- Copy 'proof/proof-token0.json' as 'proof/proof-token0-fake2.json' and change the proof parameters to generate fake
  proof which is causing exception

# Project Resources

* [Remix - Solidity IDE](https://remix.ethereum.org/)
* [Truffle Framework](https://truffleframework.com/)
* [Ganache - One Click Blockchain](https://truffleframework.com/ganache)
* [Open Zeppelin ](https://openzeppelin.org/)
* [Interactive zero knowledge 3-colorability demonstration](http://web.mit.edu/~ezyang/Public/graph/svg.html)
* [Docker](https://docs.docker.com/install/)
* [ZoKrates](https://zokrates.github.io/gettingstarted.html)
* [OpenSea](https://opensea.io/)
* [OpenSea DevDoc](https://docs.opensea.io/docs/3-viewing-your-items-on-opensea)
