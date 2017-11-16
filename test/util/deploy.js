let data = require('../data.js');
let big = require('./bigNum.js').big;
let Utility = artifacts.require('Utility');
let KeysManagerProxy = artifacts.require('KeysManagerProxy');
let ValidatorsManagerProxy = artifacts.require('ValidatorsManagerProxy');
let BallotsManagerProxy = artifacts.require('BallotsManagerProxy');

async function deployTestContracts(accounts) {
    let utilityContract = await Utility.new();
    let systemOwner = data.SYSTEM_OWNER_ADDRESS;
    let validatorsManager = await ValidatorsManagerProxy.new();
    let keysManager = await KeysManagerProxy.new();
    let ballotsManager = await BallotsManagerProxy.new();
    return {
        systemOwner,
        utilityContract,
        keysManager,
        validatorsManager,
        ballotsManager,
    }
}

module.exports = {
    deployTestContracts,
}
