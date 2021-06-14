# Udacity - Blockchain Developer Nanodegree Program

## Project 3 - Ethereum Dapp for Tracking Items through Supply Chain

### Project Details

For this project, you will creating a DApp supply chain solution backed by the Ethereum platform.

You will architect smart contracts that manage specific user permission controls as well as contracts that track and
verify a product’s authenticity.

### Required for submission info:

- Contract address: https://rinkeby.etherscan.io/address/0x3dFacD7FbC83FF51Fc4eA2F74d529De704B9E31F
- Program version number: 1.0.0 (src/js/app.js)
- Node v10.15.3
- Truffle v5.3.6 (core: 5.3.6)
- Solidity v0.5.16 (solc-js)
- Web3.js v1.3.5
- Ganache CLI v6.12.2 (ganache-core: 2.13.2)
- MetaMask 9.5.2

### 1. Part 1 - Plan the project with write-ups

#### 1.1. Requirement 1 - Project write-up - UML

##### Planning Overview

- Selected supply chain: French bread production and distribution

- Assets:
    - wheat
    - baguette

- Actors:
    - farmer
    - distributor
    - retailer
    - consumer

- Roles:

| Actor | Role |
|:---:|:---:|
|Farmer|can harvest wheat|
|Farmer|can process wheat into baguette|
|Farmer|can pack the baguette|
|Farmer|can mark the baguette for sale|
|Distributor|can buy the baguette|
|Distributor|can ship the baguette|
|Retailer|can receive the baguette|
|Consumer|can purchase the baguette|

#### Activity Diagram

![baguette-activity-diagram](res/baguette-activity-diagram.png)

##### Sequence Diagram

![baguette-sequence-diagram](res/baguette-sequence-diagram.png)

##### State Diagram

![baguette-state-diagram](res/baguette-state-diagram.png)

##### Class Diagram

![baguette-class-diagram](res/baguette-class-diagram.png)

#### 1.2. Requirement 2 - Project write-up - Libraries ️

If libraries are used in the project, the project write-up indicates which libraries and discusses why these libraries
were adopted.

| Libraries used | Version | Motivation |
|:---:|:---:|:---:|
|web3.min.js|0.19.0|To allow interaction with ethereum contracts from browser|
|truffle-contract.js|0.5.5|To allow interaction with ethereum contracts from browser|
|jquery-3.6.0.min.js|3.6.0|To build very simple front-end (the focus of the project are the contracts)|

#### 1.3. Requirement 3 - Project write-up - IPFS

If IPFS is used, the project write-up discusses how IPFS is used in this project.

| Libraries used | Version | Motivation |
|:---:|:---:|:---:|
|IPFS not used|N/A|N/A|

### 2. Part 2	Write smart contracts

#### 2.1. Requirement 1: Define and implement required interfaces

- AccessControl - Collection of Contracts: These contracts manages the various addresses and constraints for operations
  that can be executed only by specific roles.
- Base - SupplyChain.sol: This is where we define the most fundamental code shared throughout the core functionality.
  This includes our main data storage, constants and data types, plus internal functions for managing these items.
- Core - Ownable.sol: is the contract that controls ownership and transfer of ownership.

#### 2.2. Requirement 2: Build out AccessControl Contracts

#### 2.3. Requirement 3: Build out Base Contract

#### 2.4. Requirement 4: Build out Core Contract

```bash
=> ganache-cli -m "spirit supply whale amount human item harsh scare congress discover talent hamster"

Ganache CLI v6.12.2 (ganache-core: 2.13.2)

Available Accounts
==================
(0) 0x27D8D15CbC94527cAdf5eC14B69519aE23288B95 (100 ETH)
(1) 0x018C2daBef4904ECbd7118350A0c54DbeaE3549A (100 ETH)
(2) 0xCe5144391B4aB80668965F2Cc4f2CC102380Ef0A (100 ETH)
(3) 0x460c31107DD048e34971E57DA2F99f659Add4f02 (100 ETH)
(4) 0xD37b7B8C62BE2fdDe8dAa9816483AeBDBd356088 (100 ETH)
(5) 0x27f184bdc0E7A931b507ddD689D76Dba10514BCb (100 ETH)
(6) 0xFe0df793060c49Edca5AC9C104dD8e3375349978 (100 ETH)
(7) 0xBd58a85C96cc6727859d853086fE8560BC137632 (100 ETH)
(8) 0xe07b5Ee5f738B2F87f88B99Aac9c64ff1e0c7917 (100 ETH)
(9) 0xBd3Ff2E3adEd055244d66544c9c059Fa0851Da44 (100 ETH)

=> truffle compile

Compiling your contracts...
===========================
> Compiling ./contracts/Migrations.sol
> Compiling ./contracts/coffeeaccesscontrol/ConsumerRole.sol
> Compiling ./contracts/coffeeaccesscontrol/DistributorRole.sol
> Compiling ./contracts/coffeeaccesscontrol/FarmerRole.sol
> Compiling ./contracts/coffeeaccesscontrol/RetailerRole.sol
> Compiling ./contracts/coffeeaccesscontrol/Roles.sol
> Compiling ./contracts/coffeebase/SupplyChain.sol
> Compiling ./contracts/coffeecore/Ownable.sol
> Artifacts written to /Users/andreystoev/development/projects/blockchain-projects/udacity-projects/OLD/ethereum-supply-chain-n-data-auditing-dapp/project-6/build/contracts
> Compiled successfully using:
- solc: 0.5.16+commit.9c3226ce.Emscripten.clang

=> truffle migrate

Starting migrations...
======================
> Network name:    'development'
> Network id:      1621168386807
> Block gas limit: 6721975 (0x6691b7)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0x201e8d72d00c5242b83a7e3899269ae9cae0e5925bf0044825155c0c985efbf8
   > Blocks: 0            Seconds: 0
   > contract address:    0xFEeCfF2CB7d6f3BfcBE5fa41c49c8fB642f2dDbF
   > block number:        1
   > block timestamp:     1621168499
   > account:             0x27D8D15CbC94527cAdf5eC14B69519aE23288B95
   > balance:             99.99549526
   > gas used:            225237 (0x36fd5)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00450474 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00450474 ETH


2_deploy_contracts.js
=====================

   Deploying 'FarmerRole'
   ----------------------
   > transaction hash:    0x648e08d9fadeebfa6c3bf51edf133fd7e7c0635e1a8df864df4871996c05ee9f
   > Blocks: 0            Seconds: 0
   > contract address:    0xf2ee0b0Cdcae5013930B92c0Ba54F7F7f1933613
   > block number:        3
   > block timestamp:     1621168499
   > account:             0x27D8D15CbC94527cAdf5eC14B69519aE23288B95
   > balance:             99.98841844
   > gas used:            311478 (0x4c0b6)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00622956 ETH


   Deploying 'DistributorRole'
   ---------------------------
   > transaction hash:    0x15ba56027efbd12978b21f9a04ff7bedd914ba54a7157f7a08759919669d57a2
   > Blocks: 0            Seconds: 0
   > contract address:    0xd22De155853B67cE1cA3693FBE52EE958f755E7b
   > block number:        4
   > block timestamp:     1621168499
   > account:             0x27D8D15CbC94527cAdf5eC14B69519aE23288B95
   > balance:             99.98218912
   > gas used:            311466 (0x4c0aa)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00622932 ETH


   Deploying 'RetailerRole'
   ------------------------
   > transaction hash:    0x27fb361acb66de5a863c582bca2abcdc35db4409fc2b2384dabcfeceabd37456
   > Blocks: 0            Seconds: 0
   > contract address:    0x79051A2faFcC216A55d3897474012145d158F170
   > block number:        5
   > block timestamp:     1621168499
   > account:             0x27D8D15CbC94527cAdf5eC14B69519aE23288B95
   > balance:             99.97595956
   > gas used:            311478 (0x4c0b6)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00622956 ETH


   Deploying 'ConsumerRole'
   ------------------------
   > transaction hash:    0xdf595e7a1a075e0d08346b6c2c73e183b4cfbc9db078db9d78be92638968d0ca
   > Blocks: 0            Seconds: 0
   > contract address:    0xA65B87754E0A73860AA6B7eb6E95D79CD2d893d2
   > block number:        6
   > block timestamp:     1621168500
   > account:             0x27D8D15CbC94527cAdf5eC14B69519aE23288B95
   > balance:             99.96973024
   > gas used:            311466 (0x4c0aa)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00622932 ETH


   Deploying 'SupplyChain'
   -----------------------
   > transaction hash:    0xc5bac4786429cfd5b5d64fa91499ea6614a32338098cfc070d2d1b36225764bd
   > Blocks: 0            Seconds: 0
   > contract address:    0x23E2b13b08a22E9eEe431F862eC7A17aB1E99B98
   > block number:        7
   > block timestamp:     1621168500
   > account:             0x27D8D15CbC94527cAdf5eC14B69519aE23288B95
   > balance:             99.90842158
   > gas used:            3065433 (0x2ec659)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.06130866 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.08622642 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.09073116 ETH

```

### 3. Part 3	Test smart contract code coverage

#### Requirement: Smart contract has associated tests

For this project, as with any project, make sure to test your smart contracts to ensure they are working properly in
different situations without any risk.

`truffle test` => will produce [truffle test log](res/truffle-test-log.md)

### 4. Part 4	Deploy smart contracts on a public test network (Rinkeby)

#### 4.1. Requirement 1: Deploy smart contract on a public test network

Using Truffle framework, deploy your smart contract with the Rinkeby test network. Take note of your contract hash and address after successful deployment.

- install 'npm install @truffle/hdwallet-provider' if not already installed
- install 'npm install truffle-hdwallet-provider@web3-one' if not already installed
- create a file .secret in root folder with a mnemonic seed for Rinkeby network with enough credit
- create a file .rinkeby-infurakey containing your rinkeby infurakey
- be sure that you never commit .secret and .rinkeby-infurakey to GitHub (.gitignore)
- execute 'truffle migrate --network rinkeby' to deploy it to the Rinkeby network

`truffle migrate --network rinkeby`=> will produce [Rinkeby deployment log](res/rinkeby-deployment-log.md)

- contract hash: 0xa5dca8e800e007172d2bdb27673feacf30564469d647a9d8bc33fbaea973856e
- contract address: 0x3dFacD7FbC83FF51Fc4eA2F74d529De704B9E31F

#### 4.2. Requirement 2: Submit Contract Address

Provide a document with your project submission that includes the contract address.

- contract address: https://rinkeby.etherscan.io/address/0x3dFacD7FbC83FF51Fc4eA2F74d529De704B9E31F

### 5. Part 5	Modify client code to interact with smart contracts

Create the frontend that allows your users to interact with your DApp. This should be a simple and clean frontend that
manages product lifecycle as the product navigates down the supply chain.

Using javascript, create a single JS file with all web3 functions that allows your client code to interact with you
smart contracts.

#### Requirement: Configure client code for each actor

Front-end is configured to:

- Submit a product for shipment (farmer to the distributor, distributor to retailer, etc).
- Receive product from shipment.
- Validate the authenticity of the product.️

Frontend code can be downloaded and executed from a local environment.

#### Setup instructions ️

- Stop first all running ganache-cli, truffle and npm instances (required a fresh start to test the UI)
- Install ganache-cli if not already installed 'npm install -g ganache-cli'
- Start in a new terminal ganache-cli to simulate an ethereum blockchain locally with predefined addresses

```bash
=> ganache-cli -m "spirit supply whale amount human item harsh scare congress discover talent hamster"
```

- Install truffle if not already installed 'npm install -g truffle'
- Start in a new terminal truffle to deploy the contracts to the local blockchain

```bash
=> truffle compile
=> truffle migrate
```

- Install all node dependencies 'npm install'
- Make sure the first 5 addresses (contractOwnerID .. consumerId) found in src/js/app.js are exactly the same created by
  ganache-cli. If you want to use different addresses please update app.js
- Download in browser the latest MetaMask version (tested with MetaMask 9.5.2 in Chrome)
- Using Localhost 8545 import in MetaMask all accounts with the seed "spirit supply whale amount human item harsh scare
  congress discover talent hamster"

  ![Metamask Import Seed](res/metamask-import-seed.png)
- Select in MetaMask the first address which is the contract creator

  ![Metamask Select Address](res/metamask-select-addr.png)
- In case you restarted ganache or if you have change the account without refreshing the front-end, it's always a good
  idea to do Restart Account to avoid some internal MetaMask transaction state problems

  ![Metamask Reset Account](res/metamask-reset-account.png)
- Start the front-end 'npm run dev'
- Open in the browser with MetaMask 'http://localhost:3000'
- After the app has started, it will try to connect to your accounts in MetaMask. Authorize all your first 5 accounts

  ![Metamask Authorize 5 Accounts](res/metamask-auth-5-accounts.png)
- Now, the first step to do as contract creator is to assign roles to the farmer, distributor, retailer and consumer
  account. To do that:
  - Click on the button [1. Set access control for all roles (as contractOwner)]
  - After that authorize the role assignment for the four other accounts in the popups which will appear automatically

    ![Contract owner assigning roles](res/contractowner-assigning-roles.png)
  - If everything has worked fine, you should see in the bottom of UI the contract events, certifying the roles creation
- The second step in the process is to do all actions as farmer:
  - Select Account2 from MetaMask
  - Reset the account from MetaMask
  - At this point you should see in UI that the switch from contractOwner to the Farmer account has worked
  - Click the buttons [Harvest], [Process], [Pack] and [For Sale]. After each step a confirm from MetaMask will be ask
    to provide enough gas for contract execution
  - If everything has worked fine, you should see in the bottom of UI the contract events, certifying the actions
    performed
- The third step in the process is to do all actions as distributor:
  - Select Account3 from MetaMask
  - Reset the account from MetaMask
  - At this point you should see in UI that the switch from Farmer to the Distributor account has worked
  - Click the buttons [Buy] and [Ship]. After each step a confirm from MetaMask will be ask to provide enough gas for
    contract execution
  - If everything has worked fine, you should see in the bottom of UI the contract events, certifying the actions
    performed
- The fourth step in the process is to do all actions as retailer:
  - Select Account4 from MetaMask
  - Reset the account from MetaMask
  - At this point you should see in UI that the switch from Distributor to the Retailer account has worked
  - Click the button [Receive] and confirm from MetaMask to provide enough gas for contract execution
  - If everything has worked fine, you should see in the bottom of UI the contract event, certifying the action
    performed
- The fifth final step in the process is to do all actions as consumer:
  - Select Account5 from MetaMask
  - Reset the account from MetaMask
  - At this point you should see in UI that the switch from Retailer to the Consumer account has worked
  - Click the button [Purchase] and confirm from MetaMask to provide enough gas for contract execution
  - If everything has worked fine, you should see in the bottom of UI the contract event, certifying the action
    performed
- At the end you will see the whole transaction history:

```bash
Transaction History
  FarmerAdded - 0x81b1da8ec35bd49f989c2460b20f63c6e0d515604cabf7cf680c2593653ab9c3
  DistributorAdded - 0x464aa0fcac7ab5d1e398f16c2c20949f27b323f01b7df2c5ce04194bc615d86c
  RetailerAdded - 0x44480a56784f9ae9f67a546ca0b7e1c319239637816b69383d258e812bfbf1bf
  ConsumerAdded - 0x61de653122cee4c294b1b70cb1a025e9c1c226d225f4a86c3296c2a4b9a74a9c
  ConsumerAdded - 0x61de653122cee4c294b1b70cb1a025e9c1c226d225f4a86c3296c2a4b9a74a9c
  Harvested - 0x31a6219ce951732fd46c2e839e57d1836eec9d6dc099267c12b38329f1700e93
  Processed - 0x8453c4f37f792067a58044e659f21b71a2ae60f01d72c0d052fb0ec4ae0ea692
  Packed - 0x42ffa3d72ebff307351558c8e8c721107aecef176b7a663a62967c3fcc3b4a2d
  ForSale - 0x23825876619065b1fef47c4ce1037dafe27edfcb4dd2617ad7b825d9b783cd70
  ForSale - 0x23825876619065b1fef47c4ce1037dafe27edfcb4dd2617ad7b825d9b783cd70
  Sold - 0x63583915a4f6b9e4efa811a387fa94c1884a5f4b329c1796e31facde33271798
  Shipped - 0xc199b671227ba283a7556dc1500b8631c75af78cd54061d067f935409dd8d5e4
  Shipped - 0xc199b671227ba283a7556dc1500b8631c75af78cd54061d067f935409dd8d5e4
  Received - 0x82b1502b839609658ceb2494a0692c5e094193a745ef1bb69cb05fba8b140c87
  Received - 0x82b1502b839609658ceb2494a0692c5e094193a745ef1bb69cb05fba8b140c87
  Purchased - 0xa164a9cc67e327ffc0d4db368b6f6e5cc2c9efb4e3b9f12d82577c911feea101
```

(!) Please note that the reason for the duplicates (but with the same hashcode) is that when the account in UI changes,
the last event is popping out again.

(!) If you want to run the whole process again you have two options:

- opt1: Restart ganache and the whole blockchain
- opt2: Change manually in app.js the code of UPC from 1 to 2 for example and then run the UI again This is a simple
  GUI. So no effort was invested to make it usable. It's just good enough to test the contracts.
