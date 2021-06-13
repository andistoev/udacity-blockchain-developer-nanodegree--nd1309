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
   > transaction hash:    0x934fc522205dc36beeabe7e759e70138c065e2aabd2d9c468e5fc3f59a97698e
   > Blocks: 1            Seconds: 12
   > contract address:    0x6b4FA0CE19aEdfa2A2Fd4664BF2f2bF560d8A83F
   > block number:        8757234
   > block timestamp:     1623594783
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.653416718
   > gas used:            274508 (0x4304c)
   > gas price:           100 gwei
   > value sent:          0 ETH
   > total cost:          0.0274508 ETH

   Pausing for 3 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 8757235)
   > confirmation number: 2 (block: 8757236)
   > confirmation number: 3 (block: 8757237)

   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:           0.0274508 ETH


2_deploy_contracts.js
=====================

   Deploying 'SquareVerifier'
   --------------------------
   > transaction hash:    0x8ebcec969f1e5cba5f14b50ee096da99aa0a9b3d0fb86b4b1046fbf8b32fadb7
   > Blocks: 1            Seconds: 8
   > contract address:    0xc7ACE421B066A0923795E92F7cd9f898B9F7154f
   > block number:        8757239
   > block timestamp:     1623594858
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.519339518
   > gas used:            1294834 (0x13c1f2)
   > gas price:           100 gwei
   > value sent:          0 ETH
   > total cost:          0.1294834 ETH

   Pausing for 3 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 8757240)
   > confirmation number: 2 (block: 8757241)
   > confirmation number: 3 (block: 8757242)

   Deploying 'SolnSquareVerifier'
   ------------------------------
   > transaction hash:    0x8997cb0a182ee5d9904b9d539fcfbc62e379ee5d443a09cb30874361d75adaa3
   > Blocks: 0            Seconds: 8
   > contract address:    0xF4ac7aD5fCD1beBC4e8Af3bcf289b538E3B9a3ad
   > block number:        8757243
   > block timestamp:     1623594918
   > account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
   > balance:             18.092411218
   > gas used:            4269283 (0x4124e3)
   > gas price:           100 gwei
   > value sent:          0 ETH
   > total cost:          0.4269283 ETH

   Pausing for 3 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 8757244)
   > confirmation number: 2 (block: 8757245)
   > confirmation number: 3 (block: 8757246)

   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:           0.5564117 ETH


Summary
=======
> Total deployments:   3
> Final cost:          0.5838625 ETH
```
