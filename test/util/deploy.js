let data = require('../data.js');
let big = require('./bigNum.js').big;
let Utility = artifacts.require('Utility');


async function deployTestContracts(accounts) {
    let utilityContract = await Utility.new();
    let systemOwner = '0xDd0BB0e2a1594240fED0c2f2c17C1E9AB4F87126'
    return {
        systemOwner,
        utilityContract,
    }
}

module.exports = {
    deployTestContracts,
}
