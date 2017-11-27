require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let sprintf = require('sprintf');
let {addressFromNumber} = require('./util/ether.js');

let {deployTestContracts} = require('./util/deploy.js');

contract('keysManager', function(accounts) {
    let {systemOwner, keysManager} = {};

    beforeEach(async () => {
        ({systemOwner, keysManager}  = await deployTestContracts());
    });

    it('initialKeysLimit', async () => {
        data.INITIAL_KEYS_LIMIT.should.be.bignumber.equal(
            await keysManager.initialKeysLimit()
        );
    });

    it('licensesLimit', async () => {
        data.LICENSES_LIMIT.should.be.bignumber.equal(
            await keysManager.licensesLimit()
        );

    it('getLicensesLimitFromGovernance', async () => {
        (data.LICENSES_LIMIT - data.INITIAL_KEYS_LIMIT).should.be.bignumber.equal(
            await keysManager.getLicensesLimitFromGovernance()
        );
    });
    });
});
