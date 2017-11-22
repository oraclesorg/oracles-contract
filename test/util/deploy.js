let data = require('../data.js');
let big = require('./bigNum.js').big;
let Utility = artifacts.require('Utility');
let KeysStorageProxy = artifacts.require('KeysStorageProxy');
let KeysManagerProxy = artifacts.require('KeysManagerProxy');
let ValidatorsStorageProxy = artifacts.require('ValidatorsStorageProxy');
let ValidatorsManagerProxy = artifacts.require('ValidatorsManagerProxy');
let BallotsStorageProxy = artifacts.require('BallotsStorageProxy');
let BallotsManagerProxy = artifacts.require('BallotsManagerProxy');

async function deployTestContracts(accounts) {
    let utilityContract = await Utility.new();
    let systemOwner = data.SYSTEM_OWNER_ADDRESS;
    let validatorsStorage = await ValidatorsStorageProxy.new();
    let validatorsManager = await ValidatorsManagerProxy.new();
    let keysStorage = await KeysStorageProxy.new();
    let keysManager = await KeysManagerProxy.new();
    let ballotsStorage = await BallotsStorageProxy.new();
    let ballotsManager = await BallotsManagerProxy.new();

    // keys
    await keysStorage.initialize(
        keysManager.address,
        ballotsManager.address,
        validatorsStorage.address,
        validatorsManager.address,
        {from: data.SYSTEM_OWNER_ADDRESS}
    );
    // validators
    await validatorsStorage.initialize(
        validatorsManager.address,
        keysStorage.address,
        ballotsManager.address,
        {from: data.SYSTEM_OWNER_ADDRESS}
    );
    await validatorsManager.initialize(
        validatorsStorage.address,
        keysStorage.address,
        keysManager.address,
        {from: data.SYSTEM_OWNER_ADDRESS}
    );
    // ballots
    await ballotsStorage.initialize(
        ballotsManager.address,
        keysStorage.address,
        {from: data.SYSTEM_OWNER_ADDRESS}
    );
    await ballotsManager.initialize(
        ballotsStorage.address,
        keysStorage.address,
        keysManager.address,
        validatorsStorage.address,
        {from: data.SYSTEM_OWNER_ADDRESS}
    );
    
    return {
        systemOwner,
        utilityContract,
        keysStorage,
        keysManager,
        validatorsStorage,
        validatorsManager,
        ballotsStorage,
        ballotsManager,
    }
}

module.exports = {
    deployTestContracts,
}
