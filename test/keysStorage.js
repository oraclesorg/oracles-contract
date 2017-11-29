require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let {addressFromNumber} = require('./util/ether.js');
let KeysStorageProxy = artifacts.require('KeysStorageProxy');

let {deployTestContracts} = require('./util/deploy.js');

contract('keysStorage', function(accounts) {
    let {
        systemOwner,
        keysStorage,
        keysManager,
        validatorsStorage,
        validatorsManager,
        ballotsManager
    } = {};

    beforeEach(async () => {
        ({
            systemOwner,
            keysStorage,
            keysManager,
            validatorsStorage,
            validatorsManager,
            ballotsManager
            } = await deployTestContracts()
        );
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
        while(idx < data.INITIAL_KEYS_LIMIT) {
            let addr = addressFromNumber(idx);
            await keysStorage.addInitialKey(addr, {from: systemOwner});
            idx++;
        }
        let addr = addressFromNumber(idx);
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
        miningKey.should.be.equal(
            await keysStorage.votingMiningKeysPair(votingKey)
        );
        [votingKey, payoutKey].should.be.deep.equal(
            await keysStorage.miningToSecondaryKeys(miningKey)
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

    it('increaseLicenses', async () => {
        big(0).should.be.bignumber.equal(
            await keysStorage.licensesIssued()
        );
        await ballotsManager.callIncreaseLicenses();
        big(1).should.be.bignumber.equal(
            await keysStorage.licensesIssued()
        );
        // call from non-ballots-manager
        await keysStorage.increaseLicenses()
            .should.be.rejectedWith(': revert');
    });

    it('getLicensesIssuedFromGovernance', async () => {
        big(0).should.be.bignumber.equal(
            await keysStorage.getLicensesIssuedFromGovernance.call()
        );
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        big(0).should.be.bignumber.equal(
            await keysStorage.getLicensesIssuedFromGovernance.call()
        );
        await ballotsManager.callIncreaseLicenses();
        big(1).should.be.bignumber.equal(
            await keysStorage.getLicensesIssuedFromGovernance.call()
        );
    });

    it('getMiningByVoting', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        miningKey.should.be.equal(
            await keysStorage.getMiningByVoting(votingKey)
        );
    });

    it('setVotingMiningKeysPair', async () => {
        let miningKey = addressFromNumber(1);
        let votingKey = addressFromNumber(2);
        await ballotsManager.callSetVotingMiningKeysPair(votingKey, miningKey);
        miningKey.should.be.equal(
            await keysStorage.votingMiningKeysPair.call(votingKey)
        );
        // call from non-ballots-manager
        await keysStorage.setVotingMiningKeysPair(votingKey, miningKey)
            .should.be.rejectedWith(': revert');
    });

    it('getVotingByMining', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        votingKey.should.be.equal(
            await keysStorage.getVotingByMining(miningKey)
        );
    });

    it('getPayoutByMining', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        payoutKey.should.be.equal(
            await keysStorage.getPayoutByMining(miningKey)
        );
    });

    it('setMiningVotingKeysPair', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        let newVotingKey = addressFromNumber(4);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        await ballotsManager.callSetMiningVotingKeysPair(miningKey, newVotingKey);
        [newVotingKey, payoutKey].should.be.deep.equal(
            await keysStorage.miningToSecondaryKeys(miningKey)
        );
        // call from non-ballots-manager
        await keysStorage.setMiningVotingKeysPair(miningKey, newVotingKey)
            .should.be.rejectedWith(': revert');

    });

    it('setMiningPayoutKeysPair', async () => {
        let miningKey = addressFromNumber(1);
        let payoutKey = addressFromNumber(2);
        let votingKey = addressFromNumber(3);
        let newPayoutKey = addressFromNumber(4);
        await keysStorage.addInitialKey(accounts[1], {from: systemOwner});
        res = await keysStorage.createKeys(miningKey, payoutKey, votingKey, {from: accounts[1]});
        await ballotsManager.callSetMiningPayoutKeysPair(miningKey, newPayoutKey);
        [votingKey, newPayoutKey].should.be.deep.equal(
            await keysStorage.miningToSecondaryKeys(miningKey)
        );
        // call from non-ballots-manager
        await keysStorage.setMiningPayoutKeysPair(miningKey, newPayoutKey)
            .should.be.rejectedWith(': revert');

    });

    it('setVotingKey', async () => {
        let votingKey = addressFromNumber(1);
        await ballotsManager.callSetVotingKey(votingKey, true);
        true.should.be.equal(
            await keysStorage.votingKeys(votingKey)
        );
        // call from non-ballots-manager
        await keysStorage.setVotingKey(votingKey, true)
            .should.be.rejectedWith(': revert');
    });

    it('setPayoutKey', async () => {
        let payoutKey = addressFromNumber(1);
        await ballotsManager.callSetPayoutKey(payoutKey, true);
        true.should.be.equal(
            await keysStorage.payoutKeys(payoutKey)
        );
        // call from non-ballots-manager
        await keysStorage.setPayoutKey(payoutKey, true)
            .should.be.rejectedWith(': revert');
    });

    it('setKeysManager', async () => {
        let keysStorage = await KeysStorageProxy.new();
        await keysStorage.callSetKeysManager(accounts[1]);
        await keysStorage.callSetKeysManager(accounts[1])
            .should.be.rejectedWith(': revert');
    });

    it('setBallotsManager', async () => {
        let keysStorage = await KeysStorageProxy.new();
        await keysStorage.callSetBallotsManager(accounts[1]);
        await keysStorage.callSetBallotsManager(accounts[1])
            .should.be.rejectedWith(': revert');
    });

    it('setValidatorsStorage', async () => {
        let keysStorage = await KeysStorageProxy.new();
        await keysStorage.callSetValidatorsStorage(accounts[1]);
        await keysStorage.callSetValidatorsStorage(accounts[1])
            .should.be.rejectedWith(': revert');
    });

    it('setValidatorsManager', async () => {
        let keysStorage = await KeysStorageProxy.new();
        await keysStorage.callSetValidatorsManager(accounts[1]);
        await keysStorage.callSetValidatorsManager(accounts[1])
            .should.be.rejectedWith(': revert');
    });

    it('initialize', async () => {
        let keysStorage = await KeysStorageProxy.new();
        await keysStorage.initialize(
            keysManager.address,
            ballotsManager.address,
            validatorsStorage.address,
            validatorsManager.address,
            {from: systemOwner}
        );
        keysManager.address.should.be.equal(
            await keysStorage.keysManager()
        );
    });

    it('initialize fails if invalid contracts passed', async () => {
        let keysStorage = await KeysStorageProxy.new();
        await keysStorage.initialize(
                accounts[0],
                ballotsManager.address,
                validatorsStorage.address,
                validatorsManager.address,
                {from: systemOwner}
            ).should.be.rejectedWith(': revert');
        await keysStorage.initialize(
                keysManager.address,
                accounts[0],
                validatorsStorage.address,
                validatorsManager.address,
                {from: systemOwner}
            ).should.be.rejectedWith(': revert');
        await keysStorage.initialize(
                keysManager.address,
                ballotsManager.address,
                accounts[0],
                validatorsManager.address,
                {from: systemOwner}
            ).should.be.rejectedWith(': revert');
        await keysStorage.initialize(
                keysManager.address,
                ballotsManager.address,
                validatorsStorage.address,
                accounts[0],
                {from: systemOwner}
            ).should.be.rejectedWith(': revert');
    });

    it('initialize fails if called not by system owner', async () => {
        let keysStorage = await KeysStorageProxy.new();
        await keysStorage.initialize(
                keysManager.address,
                ballotsManager.address,
                validatorsStorage.address,
                validatorsManager.address,
            ).should.be.rejectedWith(': revert');
    });

});
