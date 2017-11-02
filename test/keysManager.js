require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let sprintf = require('sprintf');

let {deployTestContracts} = require('./util/deploy.js');

contract('keysManager [all features]', function(accounts) {
    let {systemOwner, keysManager} = {};

    beforeEach(async () => {
        ({systemOwner, keysManager}  = await deployTestContracts());
    });

    it('method addInitialKey is avail for admin', async () => {
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        big(1).should.be.bignumber.equal(
            await keysManager.getInitialKeysIssued.call()
        );
    });

    it('method addInitialKey is restricted for non-admin', async () => {
        await keysManager.addInitialKey(accounts[1], {from: accounts[0]})
            .should.be.rejectedWith('invalid opcode');
    });

    it('addInitialKey is allowed to add only limited number of keys', async () => {
        let idx = 0;
        while(idx < 25) {
            let addr = sprintf('0x%040x' % idx);
            await keysManager.addInitialKey(addr, {from: systemOwner});
            idx++;
        }
        let addr = sprintf('0x%040x' % idx);
        await keysManager.addInitialKey(addr, {from: systemOwner})
            .should.be.rejectedWith('invalid opcode');
    });

    it('addInitialKey changes initialKeys structure', async () => {
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        true.should.be.equal(
            await keysManager.initialKeys(accounts[1])
        );
        false.should.be.equal(
            await keysManager.initialKeys(accounts[2])
        );
    });

});

