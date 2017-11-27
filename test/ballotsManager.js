require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let {addressFromNumber} = require('./util/ether.js');
let util = require('util');

let {deployTestContracts} = require('./util/deploy.js');

contract('ballotsManager [all features]', function(accounts) {
    let {systemOwner, keysManager, validatorsStorage, ballotsManager} = {};

    beforeEach(async () => {
        ({systemOwner, keysManager, validatorsStorage, ballotsManager}  = await deployTestContracts());
    });

});
