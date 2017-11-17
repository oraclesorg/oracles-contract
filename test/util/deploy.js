let data = require('../data.js');
let big = require('./bigNum.js').big;
let Utility = artifacts.require('Utility');
let KeysManagerProxy = artifacts.require('KeysManagerProxy');
let ValidatorsManagerProxy = artifacts.require('ValidatorsManagerProxy');
let BallotsManagerProxy = artifacts.require('BallotsManagerProxy');

async function deployTestContracts(accounts) {
    let utilityContract = await Utility.new();
    let systemOwner = data.SYSTEM_OWNER_ADDRESS;
    let trueOwner = data.TRUE_OWNER_ADDRESS;
    let validatorsManager = await ValidatorsManagerProxy.new();
    let keysManager = await KeysManagerProxy.new();
    let ballotsManager = await BallotsManagerProxy.new();

    await keysManager.initialize(ballotsManager.address, validatorsManager.address, {from: "0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0"})
    await ballotsManager.initialize(keysManager.address, validatorsManager.address, {from: "0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0"});
    await validatorsManager.initialize(ballotsManager.address, keysManager.address, {from: "0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0"});
    
    return {
        systemOwner,
        trueOwner,
        utilityContract,
        keysManager,
        validatorsManager,
        ballotsManager,
    }
}

module.exports = {
    deployTestContracts,
}
