let data = require('../data.js');
let big = require('./bigNum.js').big;
let Utility = artifacts.require('Utility');
let KeysManagerProxy = artifacts.require('KeysManagerProxy');
let ValidatorsManagerProxy = artifacts.require('ValidatorsManagerProxy');


async function deployTestContracts(accounts) {
    let utilityContract = await Utility.new();
    let systemOwner = data.SYSTEM_OWNER_ADDRESS;
    let keysManager = await KeysManagerProxy.new();
    let validatorsManager = await ValidatorsManagerProxy.new();
    return {
        systemOwner,
        utilityContract,
        keysManager,
        validatorsManager,
    }
}

module.exports = {
    deployTestContracts,
}
