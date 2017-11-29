require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let {addressFromNumber} = require('./util/ether.js');
let util = require('util');
let ValidatorsManagerProxy = artifacts.require('ValidatorsManagerProxy');

let {deployTestContracts} = require('./util/deploy.js');

contract('ValidatorsManager', function(accounts) {
    let {
        systemOwner,
        keysStorage,
        keysManager,
        validatorsStorage,
        validatorsManager
    } = {};

    let keys1 = {
        mining: accounts[1],
        payout: accounts[2],
        voting: accounts[3],
    }
    let keys2 = {
        mining: addressFromNumber(4),
        payout: addressFromNumber(5),
        voting: addressFromNumber(6),
    }
    let data1 = {
        zip: big(644081),
        licenseExpiredAt: big(1893456000), // 2030 year
        licenseID: 'license-1',
        fullName: 'Ivan Ivanov',
        streetName: 'Elm Street',
        state: 'Ohio',
    };
    let data2 = {
        zip: big(123456),
        licenseExpiredAt: big(1893456111), // 2030 year + 111 seconds
        licenseID: 'license-2',
        fullName: 'Oleg Olegov',
        streetName: 'Snow Street',
        state: 'Alaska',
    };

    beforeEach(async () => {
        ({
            systemOwner,
            keysStorage,
            keysManager,
            validatorsStorage,
            validatorsManager
            }  = await deployTestContracts()
        );
    });

    it('upsertValidatorFromGovernance [update own data with voting key]', async () => {
        await keysStorage.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.insertValidatorFromCeremony(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: accounts[0]}
        );
        await keysStorage.createKeys(keys1.mining, keys1.payout, keys1.voting, {from: accounts[0]});
        await validatorsManager.upsertValidatorFromGovernance(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            'NEW STREET',
            data1.state,
            {from: keys1.voting}
        );
        [
            data1.fullName, 'NEW STREET', data1.state, big(data1.zip),
            data1.licenseID, big(data1.licenseExpiredAt), big(0), ""
        ].should.be.deep.equal(
            await validatorsStorage.validator(keys1.mining)
        );

    });

    it('insertValidatorFromCeremony [add data with initial key]', async () => {
        await keysStorage.addInitialKey(accounts[0], {from: systemOwner});
        "".should.be.equal(
            (await validatorsStorage.validator(keys1.mining))[0]
        );
        await validatorsManager.insertValidatorFromCeremony(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: accounts[0]}
        );
        [
            data1.fullName, data1.streetName, data1.state, big(data1.zip),
            data1.licenseID, big(data1.licenseExpiredAt), big(0), ""
        ].should.be.deep.equal(
            await validatorsStorage.validator(keys1.mining)
        );
    });

    it('insertValidatorFromCeremony [fails to rewrite existing data with initial key]', async () => {
        await keysStorage.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.insertValidatorFromCeremony(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: accounts[0]}
        );
        await keysStorage.addInitialKey(accounts[4], {from: systemOwner});
        await validatorsManager.insertValidatorFromCeremony(
                keys1.mining,
                data1.zip,
                data1.licenseExpiredAt,
                data1.licenseID,
                data1.fullName,
                data1.streetName,
                data1.state,
                {from: accounts[4]}
            ).should.be.rejectedWith('invalid opcode');
    });

    it('upsertValidatorFromGovernance [add new data with voting key]', async () => {
        await keysStorage.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.insertValidatorFromCeremony(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: accounts[0]}
        );
        await keysStorage.createKeys(keys1.mining, keys1.payout, keys1.voting, {from: accounts[0]});
        await validatorsManager.upsertValidatorFromGovernance(
            keys2.mining,
            data2.zip,
            data2.licenseExpiredAt,
            data2.licenseID,
            data2.fullName,
            data2.streetName,
            data2.state,
            {from: keys1.voting}
        );
        [
            data2.fullName, data2.streetName, data2.state, big(data2.zip),
            data2.licenseID, big(data2.licenseExpiredAt), big(0), ""
        ].should.be.deep.equal(
            await validatorsStorage.validator(keys2.mining)
        );

    });

    it('setValidatorsStorage', async () => {
        let validatorsManager = await ValidatorsManagerProxy.new();
        await validatorsManager.setValidatorsStorage(
            validatorsStorage.address, {from: systemOwner}
        );
        await validatorsManager.setValidatorsStorage(
                validatorsStorage.address, {from: systemOwner}
            ).should.be.rejectedWith(': revert');
    });

    it('setKeysStorage', async () => {
        let validatorsManager = await ValidatorsManagerProxy.new();
        await validatorsManager.setKeysStorage(
            keysStorage.address, {from: systemOwner}
        );
        await validatorsManager.setKeysStorage(
                keysStorage.address, {from: systemOwner}
            ).should.be.rejectedWith(': revert');
    });

    it('setKeysManager', async () => {
        let validatorsManager = await ValidatorsManagerProxy.new();
        await validatorsManager.setKeysManager(
            keysManager.address, {from: systemOwner}
        );
        await validatorsManager.setKeysManager(
                keysManager.address, {from: systemOwner}
            ).should.be.rejectedWith(': revert');
    });

});
