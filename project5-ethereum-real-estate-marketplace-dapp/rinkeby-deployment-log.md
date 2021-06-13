```bash
➜  project5-ethereum-real-estate-marketplace-dapp git:(master) ✗ truffle migrate --network rinkeby

Compiling your contracts...
===========================
✔ Fetching solc version list from solc-bin. Attempt #1
> Everything is up to date, there is nothing to compile.



Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 10000000 (0x989680)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0xdc23bc3cb9794938fae814d522e461d9a95de7406e81ef56b357715557e053ab
   > Blocks: 1            Seconds: 12
   > contract address:    0x3c40cB77854b2A5271995B108fAb28811c6427BE
   > block number:        8757429
   > block timestamp:     1623597708
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.062076618
   > gas used:            274508 (0x4304c)
   > gas price:           100 gwei
   > value sent:          0 ETH
   > total cost:          0.0274508 ETH

   Pausing for 3 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 8757430)
   > confirmation number: 2 (block: 8757431)
   > confirmation number: 3 (block: 8757432)

   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:           0.0274508 ETH


2_deploy_contracts.js
=====================

   Deploying 'SquareVerifier'
   --------------------------
   > transaction hash:    0xddc1d9edf80e2abb419cd4aae1bbb5c577e125abaed2b4c897e507041130a743
   > Blocks: 0            Seconds: 8
   > contract address:    0x0e50192ba7F417B6256f8bA16FAD1b1a1b049D97
   > block number:        8757434
   > block timestamp:     1623597783
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             17.927999418
   > gas used:            1294834 (0x13c1f2)
   > gas price:           100 gwei
   > value sent:          0 ETH
   > total cost:          0.1294834 ETH

   Pausing for 3 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 8757435)
   > confirmation number: 2 (block: 8757436)
   > confirmation number: 3 (block: 8757437)

   Deploying 'SolnSquareVerifier'
   ------------------------------
   > transaction hash:    0x72bfbd988003ec25f945997609b32d23047eeaf83fa074a46cf649788a5d9ccf
   > Blocks: 0            Seconds: 8
   > contract address:    0x7a973865a6027170A5394612071FAC4E4F971795
   > block number:        8757438
   > block timestamp:     1623597843
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             17.501071118
   > gas used:            4269283 (0x4124e3)
   > gas price:           100 gwei
   > value sent:          0 ETH
   > total cost:          0.4269283 ETH

   Pausing for 3 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 8757439)
   > confirmation number: 2 (block: 8757440)
   > confirmation number: 3 (block: 8757441)

   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:           0.5564117 ETH


Summary
=======
> Total deployments:   3
> Final cost:          0.5838625 ETH
```
