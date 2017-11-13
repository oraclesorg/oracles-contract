require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let sprintf = require('sprintf');
let {addressFromNumber} = require('./util/ether.js');

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

    it('initialKeysIssued affected by addInitialKey', async () => {
        big(0).should.be.bignumber.equal(
            await keysManager.getInitialKeysIssued.call()
        );
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        big(1).should.be.bignumber.equal(
            await keysManager.getInitialKeysIssued.call()
        );
    });

    it('method addInitialKey is restricted for non-admin', async () => {
        await keysManager.addInitialKey(accounts[1], {from: accounts[0]})
            .should.be.rejectedWith('transaction: revert');
    });

    it('addInitialKey is allowed to add only limited number of keys', async () => {
        let idx = 0;
        while(idx < 25) {
            let addr = addressFromNumber(idx);//sprintf('0x%040x' % idx);
            await keysManager.addInitialKey(addr, {from: systemOwner});
            idx++;
        }
        let addr = addressFromNumber(idx);//sprintf('0x%040x' % idx);
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

    it('checkInitialKey', async () => {
        false.should.be.equal(
            await keysManager.checkInitialKey.call(accounts[1])
        );
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        true.should.be.equal(
            await keysManager.checkInitialKey.call(accounts[1])
        );
    });

    it('initial key is invalidated after being used in createKeys', async () => {
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        await keysManager.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]});
        false.should.be.equal(
            await keysManager.checkInitialKey.call(accounts[1])
        );
    });

    it('createKeys fails for invalid initial key', async () => {
        await keysManager.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]})
            .should.be.rejectedWith('invalid opcode');
    });

    it('createKeys fails for used initial key', async () => {
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        await keysManager.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]});
        await keysManager.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]})
            .should.be.rejectedWith('invalid opcode');
    });

    it('licensesIssued is incremented by createKeys', async () => {
        big(0).should.be.bignumber.equal(
            await keysManager.getLicensesIssued()
        );
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        await keysManager.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]});
        big(1).should.be.bignumber.equal(
            await keysManager.getLicensesIssued()
        );
    });

    it('createKeys modifies keysManager state', async() => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysManager.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        true.should.be.equal(
            await keysManager.miningKeys(miningKey)
        );
        true.should.be.equal(
            await keysManager.payoutKeys(payoutKey)
        );
        true.should.be.equal(
            await keysManager.votingKeys(votingKey)
        );
        miningKey.should.be.equal(
            await keysManager.validators(0)
        );
    });

    it('createKeys generates event', async() => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysManager.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        'InitiateChange'.should.be.equal(res.logs[0].event);
        [miningKey].should.be.deep.equal(
            res.logs[0].args['_new_set']
        );
        let parentBlockHash = await web3.eth.getBlock(await web3.eth.blockNumber - 1).hash;
        parentBlockHash.should.be.equal(
            res.logs[0].args['_parent_hash']
        );
    });

    it('checkPayoutKeyValidity', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysManager.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        true.should.be.equal(
            await keysManager.checkPayoutKeyValidity(payoutKey)
        );
        false.should.be.equal(
            await keysManager.checkPayoutKeyValidity(votingKey)
        );
    });

    it('checkVotingKeyValidity', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysManager.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        true.should.be.equal(
            await keysManager.checkVotingKeyValidity(votingKey)
        );
        false.should.be.equal(
            await keysManager.checkVotingKeyValidity(payoutKey)
        );
    });

    it('addInitialKey fails to add same key twice', async () => {
        await keysManager.addInitialKey(accounts[1], {from: systemOwner});
        await keysManager.addInitialKey(accounts[1], {from: systemOwner})
            .should.be.rejectedWith('invalid opcode');
    });

});
