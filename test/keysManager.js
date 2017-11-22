require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let sprintf = require('sprintf');
let {addressFromNumber} = require('./util/ether.js');

let {deployTestContracts} = require('./util/deploy.js');

contract('keysStorage [all features]', function(accounts) {
    let {systemOwner, keysStorage, keysManager, validatorsStorage} = {};

    beforeEach(async () => {
        ({systemOwner, keysStorage, keysManager, validatorsStorage}  = await deployTestContracts());
    });

    it('method addInitialKey is avail for admin', async () => {
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        big(1).should.be.bignumber.equal(
            await keysStorage.initialKeysIssued()
        );
    });

    it('initialKeysIssued affected by addInitialKey', async () => {
        big(0).should.be.bignumber.equal(
            await keysStorage.initialKeysIssued()
        );
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        big(1).should.be.bignumber.equal(
            await keysStorage.initialKeysIssued()
        );
    });

    it('method addInitialKey is restricted for non-admin', async () => {
        await keysStorage.addInitialKey(accounts[1], {from: accounts[0]})
            .should.be.rejectedWith('transaction: revert');
    });

    it('addInitialKey is allowed to add only limited number of keys', async () => {
        let idx = 0;
        let initialKeysLimit = await keysManager.initialKeysLimit.call();
        while(idx < initialKeysLimit) {
            let addr = addressFromNumber(idx);//sprintf('0x%040x' % idx);
            await keysStorage.addInitialKey(addr, {from: systemOwner});
            idx++;
        }
        let addr = addressFromNumber(idx);//sprintf('0x%040x' % idx);
        await keysStorage.addInitialKey(addr, {from: systemOwner})
            .should.be.rejectedWith('invalid opcode');
    });

    it('addInitialKey changes initialKeys structure', async () => {
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        true.should.be.equal(
            await keysStorage.initialKeys(accounts[1])
        );
        false.should.be.equal(
            await keysStorage.initialKeys(accounts[2])
        );
    });

    it('checkInitialKey', async () => {
        false.should.be.equal(
            await keysStorage.checkInitialKey.call(accounts[1])
        );
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        true.should.be.equal(
            await keysStorage.checkInitialKey.call(accounts[1])
        );
    });

    it('initial key is invalidated after being used in createKeys', async () => {
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        await keysStorage.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]});
        false.should.be.equal(
            await keysStorage.checkInitialKey.call(accounts[1])
        );
    });

    it('addInitialKey fails to add same key twice', async () => {
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner})
            .should.be.rejectedWith('invalid opcode');
    });

    it('createKeys fails for invalid initial key', async () => {
        await keysStorage.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]})
            .should.be.rejectedWith('invalid opcode');
    });

    it('createKeys fails for used initial key', async () => {
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        await keysStorage.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]});
        await keysStorage.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]})
            .should.be.rejectedWith('invalid opcode');
    });

    it('licensesIssued is incremented by createKeys', async () => {
        big(0).should.be.bignumber.equal(
            await keysStorage.licensesIssued()
        );
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        await keysStorage.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]});
        big(1).should.be.bignumber.equal(
            await keysStorage.licensesIssued()
        );
    });

    it('initialKeysInvalidated is incremented by createKeys', async () => {
        big(0).should.be.bignumber.equal(
            await keysStorage.initialKeysInvalidated()
        );
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        await keysStorage.createKeys(accounts[2], accounts[3], accounts[4], {from: accounts[1]});
        big(1).should.be.bignumber.equal(
            await keysStorage.initialKeysInvalidated()
        );
    });

    it('createKeys modifies keysStorage state', async() => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        let i = await keysStorage.miningKeys(miningKey)
        true.should.be.equal(
            await keysStorage.miningKeys(miningKey)
        );
        true.should.be.equal(
            await keysStorage.payoutKeys(payoutKey)
        );
        true.should.be.equal(
            await keysStorage.votingKeys(votingKey)
        );
        miningKey.should.be.equal(
            await validatorsStorage.validators(1)
        );
    });

    /*it('createKeys generates event', async() => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        'InitiateChange'.should.be.equal(res.logs[0].event);
        [miningKey].should.be.deep.equal(
            res.logs[0].args['_new_set']
        );
        let parentBlockHash = await web3.eth.getBlock(await web3.eth.blockNumber - 1).hash;
        parentBlockHash.should.be.equal(
            res.logs[0].args['_parent_hash']
        );
    });*/

    it('checkMiningKeyValidity', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        false.should.be.equal(
            await keysStorage.checkMiningKeyValidity(payoutKey)
        );
        false.should.be.equal(
            await keysStorage.checkMiningKeyValidity(votingKey)
        );
        true.should.be.equal(
            await keysStorage.checkMiningKeyValidity(miningKey)
        );
    });

    it('checkPayoutKeyValidity', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        true.should.be.equal(
            await keysStorage.checkPayoutKeyValidity(payoutKey)
        );
        false.should.be.equal(
            await keysStorage.checkPayoutKeyValidity(votingKey)
        );
        false.should.be.equal(
            await keysStorage.checkPayoutKeyValidity(miningKey)
        );
    });

    it('checkVotingKeyValidity', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        true.should.be.equal(
            await keysStorage.checkVotingKeyValidity(votingKey)
        );
        false.should.be.equal(
            await keysStorage.checkVotingKeyValidity(payoutKey)
        );
        false.should.be.equal(
            await keysStorage.checkVotingKeyValidity(miningKey)
        );
    });

});
