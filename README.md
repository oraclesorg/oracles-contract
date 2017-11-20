# Oracles POA Network smart contracts
Ethereum smart contracts to manage validators in Oracles POA Network 

- [Oracles POA Network smart contracts](#oracles-poa-network-smart-contracts)
  * [Oracles POA Network contracts features checklist](#oracles-poa-network-contracts-features-checklist)
    + [ValidatorsStorage and ValidatorsManager contracts](#validatorsstorage-and-validatorsmanager-contracts)
    + [KeysStorage and KeysManager contracts](#keysstorage-and-keysmanager-contracts)
    + [BallotsStorage and BallotsManager contracts](#ballotsstorage-and-ballotsmanager-contracts)
  * [Known Ethereum contracts attack vectors checklist](#known-ethereum-contracts-attack-vectors-checklist)
  * [Compiling of Oracles contract](#compiling-of-oracles-contract)
  * [How to run tests](#how-to-run-tests)

## Oracles POA Network contracts features checklist

### [ValidatorsStorage](https://github.com/oraclesorg/oracles-contract/blob/master/src/ValidatorsStorage.sol) and [ValidatorsManager](https://github.com/oraclesorg/oracles-contract/blob/master/src/ValidatorsManager.sol) contracts.

These are contracts for storing and managing the data for validators.

| № | Description                                             | Status |
|---|:-----------------------------------------------------|:--------------------------:|
| 1 | Validator's personal data addition is available for valid initial key from ceremony     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 2 | Validator's personal data addition is forbidden for invalid initial key from ceremony    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 3 | Validator's personal data addition is forbidden for the same valid initial key from ceremony twice    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 4 | Validator's personal data addition is forbidden from ceremony, if counter of initial keys, invalidated from ceremony, reached the limit    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 5 | Validator's personal data addition is available for valid voting key from governance     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 6 | Validator's personal data addition is forbidden for invalid voting key from governance    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 7 | Validator's personal data addition is forbidden for the same valid voting key from governance twice    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 8 | Validator's personal data addition is forbidden from governance, if counter of validators, added from governance, reached the limit    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 9 | Mining key is added to validators' array after generation of new production keys   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 10 | Personal data: output zip code is equal to input zip code and it is a bignumber   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 11 | Personal data: output licenseExpiredAt is equal to input licenseExpiredAt and it is a bignumber   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 12 | Personal data: output licenseID is equal to input licenseID   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 13 | Personal data: output fullname is equal to input fullname   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 14 | Personal data: output streetname is equal to input streetname   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 15 | Personal data: output state is equal to input state   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 16 | Personal data: output sisablingDate is empty   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |

### [KeysStorage](https://github.com/oraclesorg/oracles-contract/blob/master/src/KeysStorage.sol) and [KeysManager](https://github.com/oraclesorg/oracles-contract/blob/master/src/KeysManager.sol) contracts.

These are contracts for storing and managing the data for [Oracles POA Network Keys Generation dApp](https://github.com/oraclesorg/oracles-dapps-keys-generation).

| № | Description                                             | Status |
|---|:-----------------------------------------------------|:--------------------------:|
| 1 | Initial key addition is available for contract owner     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 2 | Initial key addition fails to add same key twice    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 3 | Initial key is valid after execution of `addInitialKey` function     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 4 | Initial key generation is forbidden for non-owner of contract    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 5 | It is allowed to add only limited number of initial keys (25)     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 6 | Production keys generation fails for invalid initial key     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 7 | Production keys generation fails for used initial key     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 8 | Licenses counter is incremented by generation of production keys     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 9 | Initial keys invalidation counter is incremented by generation of production keys     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 10 | Mining, voting and payout keys are generated after execution `createKeys`  function, and they are valid     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 11 | Initial key is invalidated immediately after mining/payout/voting keys are created     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |

### [BallotsStorage](https://github.com/oraclesorg/oracles-contract/blob/master/src/BallotsStorage.sol) and [BallotsManager](https://github.com/oraclesorg/oracles-contract/blob/master/src/BallotsManager.sol) contracts.

These are contracts for storing and managing the data for [Oracles POA Network Governance dApp](https://github.com/oraclesorg/oracles-dapps-voting).

To be done...

## Known Ethereum contracts attack vectors checklist

| № | Attack vector                  | Description                                                        | Status |
|---|:-----------------------------------------------------|:-----------------------------------------------------|:--------------------------:|
| 1 | [Race Conditions](https://github.com/ConsenSys/smart-contract-best-practices#race-conditions)     | The order of transactions themselves (within a block) is easily subject to manipulation | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 1.a | [Reentrancy](https://github.com/ConsenSys/smart-contract-best-practices#reentrancy)     | Functions can be called repeatedly, before the first invocation of the function was finished | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 1.b | [Cross-function Race Conditions](https://github.com/ConsenSys/smart-contract-best-practices#cross-function-race-conditions)     | A similar attack using two different functions that share the same state | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 1.c | [Pitfalls in Race Condition Solutions](https://github.com/ConsenSys/smart-contract-best-practices#cross-function-race-conditions)     | Avoiding of calling functions which call external functions | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 2 | [Timestamp Dependence](https://github.com/ConsenSys/smart-contract-best-practices#timestamp-dependence)     | Timestamp of the block can be manipulated by the miner | |
| 3 | [Integer Overflow and Underflow](https://github.com/ConsenSys/smart-contract-best-practices#integer-overflow-and-underflow)     | Usage of unlimited increments can cause such issue  | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 4 | [DoS with (Unexpected) Throw](https://github.com/ConsenSys/smart-contract-best-practices#dos-with-unexpected-throw)     | Unexpected throw is reached with some contract method for any user, because of malicious user called it before with bad parameters | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 5 | [DoS with Block Gas Limit](https://github.com/ConsenSys/smart-contract-best-practices#dos-with-block-gas-limit)     |  Block gas limit can be reached, for example, with looping through an array with unknown size and sending `send()` in a single transaction. Sending should be divided to multiple transactions| ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |

## Compiling of Oracles contract
Install [dapp cli](http://dapp.readthedocs.io/en/latest/installation.html#installing-dapp)

1) `git clone https://github.com/oraclesorg/oracles-contract` // clone repository

2) `cd oracles-contract/` // move to folder with project

3) `git submodule update --init --recursive` // get submodules data

4) `dapp build` // compiling of contracts to `./out`

Expected result: 

`./out/Oracles.bin` - bytecode of Oracles contract

`./out/Oracles.abi` - binary interface of Oracles contract


## How to run tests

* First you need to create symlinks so solidity compiler be able to import contracts from
    oraceles-contract-key, oracles-contract-validator and oracles-contract-ballot directories.
    Just run `make symlinks` command or do it manually (see details in Makefile)
* Then run testrpc with specifica accounts and balances. Use `make testrpc` command.
* Now you can run tests with command `truffle test`.