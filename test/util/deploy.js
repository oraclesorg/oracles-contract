let data = require('../data.js');
let big = require('./bigNum.js').big;
let Utility = artifacts.require('Utility');
let KeysManagerProxy = artifacts.require('KeysManagerProxy');


async function deployTestContracts(accounts) {
    let utilityContract = await Utility.new();
    let systemOwner = data.SYSTEM_OWNER_ADDRESS;
    let keysManager = await KeysManagerProxy.new();
    return {
        systemOwner,
        utilityContract,
        keysManager,
    }
}

module.exports = {
    deployTestContracts,
}
