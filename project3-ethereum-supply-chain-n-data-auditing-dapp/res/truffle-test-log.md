```bash
=> truffle test

Using network 'development'.


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
> Artifacts written to /var/folders/2x/lcmsy14s0tb10ty3c8v_67jc0000gp/T/test--24338-oblep2d5eDK7
> Compiled successfully using:
   - solc: 0.5.16+commit.9c3226ce.Emscripten.clang

ganache-cli accounts used here...
Contract Owner: accounts[0]  0x27D8D15CbC94527cAdf5eC14B69519aE23288B95
Farmer: accounts[1]  0x018C2daBef4904ECbd7118350A0c54DbeaE3549A
Distributor: accounts[2]  0xCe5144391B4aB80668965F2Cc4f2CC102380Ef0A
Retailer: accounts[3]  0x460c31107DD048e34971E57DA2F99f659Add4f02
Consumer: accounts[4]  0xD37b7B8C62BE2fdDe8dAa9816483AeBDBd356088


  Contract: SupplyChain
    ✓ Testing smart contract function harvestItem() that allows a farmer to harvest coffee (150ms)
    ✓ Testing smart contract function processItem() that allows a farmer to process coffee (130ms)
    ✓ Testing smart contract function packItem() that allows a farmer to pack coffee (124ms)
    ✓ Testing smart contract function markItemForSale() that allows a farmer to sell coffee (124ms)
    ✓ Testing smart contract function buyItem() that allows a distributor to buy coffee (139ms)
    ✓ Testing smart contract function shipItem() that allows a distributor to ship coffee (137ms)
    ✓ Testing smart contract function receiveItem() that allows a retailer to mark coffee received (145ms)
    ✓ Testing smart contract function purchaseItem() that allows a consumer to purchase coffee (154ms)
    ✓ Testing smart contract function fetchItemBufferOne() that allows anyone to fetch item details from blockchain (49ms)
    ✓ Testing smart contract function fetchItemBufferTwo() that allows anyone to fetch item details from blockchain


  10 passing (2s)
```
