```bash
=> truffle migrate --network rinkeby

Compiling your contracts...
===========================
✔ Fetching solc version list from solc-bin. Attempt #1
> Everything is up to date, there is nothing to compile.



Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 10001629 (0x989cdd)


1_initial_migration.js
======================

Deploying 'Migrations'
----------------------
> transaction hash:    0x39b4d7dee9df6347694306be5471d96ba6426bdd47a934ed0fc2971dfeabad2d
> Blocks: 1            Seconds: 12
> contract address:    0x66465Ad3e39FDE001Ad9B8F1AdE3Db17660464Ef
> block number:        8758606
> block timestamp:     1623615364
> account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
> balance:             11.876854869
> gas used:            274508 (0x4304c)
> gas price:           100 gwei
> value sent:          0 ETH
> total cost:          0.0274508 ETH

Pausing for 2 confirmations...
------------------------------
> confirmation number: 1 (block: 8758607)
> confirmation number: 2 (block: 8758608)

> Saving migration to chain.
> Saving artifacts
   -------------------------------------
> Total cost:           0.0274508 ETH


2_deploy_contracts.js
=====================

Deploying 'SquareVerifier'
--------------------------
> transaction hash:    0x4b1df6b5214aa4c12b36bcc95a6cbc88935d481ec6141be046e582d86e35a190
> Blocks: 1            Seconds: 8
> contract address:    0x7c3f2fEe85378bE7bA697505440B43b9BC6fA2c1
> block number:        8758610
> block timestamp:     1623615425
> account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
> balance:             11.742777669
> gas used:            1294834 (0x13c1f2)
> gas price:           100 gwei
> value sent:          0 ETH
> total cost:          0.1294834 ETH

Pausing for 2 confirmations...
------------------------------
> confirmation number: 1 (block: 8758611)
> confirmation number: 2 (block: 8758612)

Deploying 'SolnSquareVerifier'
------------------------------
> transaction hash:    0x42cee83f047466f83f2b686194fdf4ab61a920b76323e92d33313b898eae57e8
> Blocks: 1            Seconds: 12
> contract address:    0xFf21fb7154c2286Fe6F9156A768EB7d6d9ABb5dF
> block number:        8758613
> block timestamp:     1623615470
> account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
> balance:             11.318765869
> gas used:            4240118 (0x40b2f6)
> gas price:           100 gwei
> value sent:          0 ETH
> total cost:          0.4240118 ETH

Pausing for 2 confirmations...
------------------------------
> confirmation number: 1 (block: 8758614)
> confirmation number: 2 (block: 8758615)

> Saving migration to chain.
> Saving artifacts
   -------------------------------------
> Total cost:           0.5534952 ETH


Summary
=======
> Total deployments:   3
> Final cost:          0.580946 ETH
```
