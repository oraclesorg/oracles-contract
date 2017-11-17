let data = require('../data.js');
let big = require('./bigNum.js').big;
let Utility = artifacts.require('Utility');
let KeysStorageProxy = artifacts.require('KeysStorageProxy');
let KeysManagerProxy = artifacts.require('KeysManagerProxy');
let ValidatorsStorageProxy = artifacts.require('ValidatorsStorageProxy');
let ValidatorsManagerProxy = artifacts.require('ValidatorsManagerProxy');
let BallotsManagerProxy = artifacts.require('BallotsManagerProxy');

async function deployTestContracts(accounts) {
    let utilityContract = await Utility.new();
    let systemOwner = data.SYSTEM_OWNER_ADDRESS;
    let trueOwner = data.TRUE_OWNER_ADDRESS;
    let validatorsStorage = await ValidatorsStorageProxy.new();
    let validatorsManager = await ValidatorsManagerProxy.new();
    let keysStorage = await KeysStorageProxy.new();
    let keysManager = await KeysManagerProxy.new();
    let ballotsManager = await BallotsManagerProxy.new();

    await validatorsStorage.initialize(validatorsManager.address, keysStorage.address, ballotsManager.address, {from: "0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0"});
    await keysStorage.initialize(keysManager.address, ballotsManager.address, validatorsStorage.address, validatorsManager.address, {from: "0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0"})
    await validatorsManager.initialize(validatorsStorage.address, keysStorage.address, keysManager.address, {from: "0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0"});
    await ballotsManager.initialize(keysStorage.address, keysManager.address, validatorsStorage.address, validatorsManager.address, {from: "0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0"});
    
    return {
        systemOwner,
        trueOwner,
        utilityContract,
        keysStorage,
        keysManager,
        validatorsStorage,
        validatorsManager,
        ballotsManager,
    }
}

module.exports = {
    deployTestContracts,
}
