let data = require('../data.js');
let big = require('./bigNum.js').big;
let Utility = artifacts.require('Utility');


async function deployTestContracts(accounts) {
    let utilityContract = await Utility.new();
    return {
        utilityContract,
    }
}

module.exports = {
    deployTestContracts,
}
