```bash
=> truffle migrate --network rinkeby

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
> Artifacts written to /Users/andreystoev/development/projects/blockchain-projects/udacity-projects/udacity-blockchain-developer-nanodegree--nd1309/project3-ethereum-supply-chain-n-data-auditing-dapp/build/contracts
> Compiled successfully using:
   - solc: 0.5.16+commit.9c3226ce.Emscripten.clang



Migrations dry-run (simulation)
===============================
> Network name:    'rinkeby-fork'
> Network id:      4
> Block gas limit: 10000000 (0x989680)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > block number:        8595781
   > block timestamp:     1621172083
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.724983868
   > gas used:            210237 (0x3353d)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00210237 ETH

   -------------------------------------
   > Total cost:          0.00210237 ETH


2_deploy_contracts.js
=====================

   Deploying 'FarmerRole'
   ----------------------
   > block number:        8595783
   > block timestamp:     1621172093
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.721745458
   > gas used:            296478 (0x4861e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00296478 ETH


   Deploying 'DistributorRole'
   ---------------------------
   > block number:        8595784
   > block timestamp:     1621172100
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.718780918
   > gas used:            296454 (0x48606)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00296454 ETH


   Deploying 'RetailerRole'
   ------------------------
   > block number:        8595785
   > block timestamp:     1621172107
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.715816138
   > gas used:            296478 (0x4861e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00296478 ETH


   Deploying 'ConsumerRole'
   ------------------------
   > block number:        8595786
   > block timestamp:     1621172114
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.712851358
   > gas used:            296478 (0x4861e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00296478 ETH


   Deploying 'SupplyChain'
   -----------------------
   > block number:        8595787
   > block timestamp:     1621172137
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.683247148
   > gas used:            2960421 (0x2d2c25)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.02960421 ETH

   -------------------------------------
   > Total cost:          0.04146309 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.04356546 ETH





Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 10000000 (0x989680)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0x9980c107bddb2f186f82f4cbbaf7f4a8022c519b1b4024a433a151922bcffdb7
   > Blocks: 1            Seconds: 16
   > contract address:    0xD858234eC4e6A3054FD449eD95E5C51d27417BEd
   > block number:        8595786
   > block timestamp:     1621172169
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.724820868
   > gas used:            226537 (0x374e9)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00226537 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00226537 ETH


2_deploy_contracts.js
=====================

   Deploying 'FarmerRole'
   ----------------------
   > transaction hash:    0x1f4fde844697775a7e530c1f6fb9281b7c99b5c6bb0bedd69480d6dee6915f21
   > Blocks: 1            Seconds: 12
   > contract address:    0x02DACb192Db7f8060dC04735A297e536E59dcEE8
   > block number:        8595788
   > block timestamp:     1621172199
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.721242458
   > gas used:            312078 (0x4c30e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00312078 ETH


   Deploying 'DistributorRole'
   ---------------------------
   > transaction hash:    0xa8c717990dcdca8a315b1b3708aaf66302aa36b7d284f1415445c455bf36174b
   > Blocks: 0            Seconds: 8
   > contract address:    0x0211355791B48882353690A44bE960Ec0EB5cD84
   > block number:        8595789
   > block timestamp:     1621172214
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.718121918
   > gas used:            312054 (0x4c2f6)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00312054 ETH


   Deploying 'RetailerRole'
   ------------------------
   > transaction hash:    0xd97807217d02da50718b040f2e6ec47c2b9e35d34223ddba0124f29179274312
   > Blocks: 0            Seconds: 8
   > contract address:    0x38c86D74A08D09f1445C986575606539fCb477FF
   > block number:        8595790
   > block timestamp:     1621172229
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.715001138
   > gas used:            312078 (0x4c30e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00312078 ETH


   Deploying 'ConsumerRole'
   ------------------------
   > transaction hash:    0xc27a80ad3b8ddc12acb9b5abdcfaf5c5d0a39d4d232d500c6d530e7c68029232
   > Blocks: 0            Seconds: 8
   > contract address:    0x0236bE40F67FF5188A08E944a59A128a04397396
   > block number:        8595791
   > block timestamp:     1621172244
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.711880358
   > gas used:            312078 (0x4c30e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00312078 ETH


   Deploying 'SupplyChain'
   -----------------------
   > transaction hash:    0xa5dca8e800e007172d2bdb27673feacf30564469d647a9d8bc33fbaea973856e
   > Blocks: 1            Seconds: 8
   > contract address:    0x3dFacD7FbC83FF51Fc4eA2F74d529De704B9E31F
   > block number:        8595792
   > block timestamp:     1621172259
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.681154148
   > gas used:            3072621 (0x2ee26d)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.03072621 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.04320909 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.04547446 ETH
```
