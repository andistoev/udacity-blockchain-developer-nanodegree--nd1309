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
> transaction hash:    0xbd29a7d5e36ab53a183b9cf43c52c8cde24045d8de85f3aa5635d4491dbd95fc
> Blocks: 0            Seconds: 8
> contract address:    0xC2B1BBF1D192A2e99B20fC7228b36ECa22Fbd790
> block number:        8757985
> block timestamp:     1623606048
> account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
> balance:             17.470736518
> gas used:            274508 (0x4304c)
> gas price:           100 gwei
> value sent:          0 ETH
> total cost:          0.0274508 ETH

Pausing for 3 confirmations...
------------------------------
> confirmation number: 1 (block: 8757986)
> confirmation number: 2 (block: 8757987)
> confirmation number: 3 (block: 8757988)

> Saving migration to chain.
> Saving artifacts
   -------------------------------------
> Total cost:           0.0274508 ETH


2_deploy_contracts.js
=====================

Deploying 'SquareVerifier'
--------------------------
> transaction hash:    0xb555cb847accfeaea9a03b97b193cdbc7bfe4f5ff63ff398bcaeaa1b4337a268
> Blocks: 1            Seconds: 12
> contract address:    0xd3171E21A4a8e86524567f5CeB3cdef3a5f5Da2b
> block number:        8757990
> block timestamp:     1623606123
> account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
> balance:             17.336659318
> gas used:            1294834 (0x13c1f2)
> gas price:           100 gwei
> value sent:          0 ETH
> total cost:          0.1294834 ETH

Pausing for 3 confirmations...
------------------------------
> confirmation number: 1 (block: 8757991)
> confirmation number: 2 (block: 8757992)
> confirmation number: 3 (block: 8757993)

Deploying 'SolnSquareVerifier'
------------------------------
> transaction hash:    0x7b22768f21fe7d9922263bda520f2197e57bda6dc5f9792f07ad1b38e1105626
> Blocks: 0            Seconds: 12
> contract address:    0x87b61A0E1F1388875b12a11D1441a0BCb822E618
> block number:        8757994
> block timestamp:     1623606183
> account:             0x637E7075fc1B2D30d23D9Da79581eBE8Df531c89
> balance:             16.912643918
> gas used:            4240154 (0x40b31a)
> gas price:           100 gwei
> value sent:          0 ETH
> total cost:          0.4240154 ETH

Pausing for 3 confirmations...
------------------------------
> confirmation number: 1 (block: 8757995)
> confirmation number: 2 (block: 8757996)
> confirmation number: 3 (block: 8757997)

> Saving migration to chain.
> Saving artifacts
   -------------------------------------
> Total cost:           0.5534988 ETH


Summary
=======
> Total deployments:   3
> Final cost:          0.5809496 ETH
