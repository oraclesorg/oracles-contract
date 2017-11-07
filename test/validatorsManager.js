require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let sprintf = require('sprintf');
let {addressFromNumber} = require('./util/ether.js');
let util = require('util');

let {deployTestContracts} = require('./util/deploy.js');

contract('validatorsManager [all features]', function(accounts) {
    let {systemOwner, validatorsManager} = {};
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
        ({systemOwner, validatorsManager}  = await deployTestContracts());
    });

    it('getValidators', async () => {
        await validatorsManager.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.createKeys(keys1.mining, keys1.payout, keys1.voting, {from: accounts[0]});
        await validatorsManager.addInitialKey(accounts[4], {from: systemOwner});
        await validatorsManager.createKeys(keys2.mining, keys2.payout, keys2.voting, {from: accounts[4]});
        [keys1.mining, keys2.mining].should.be.deep.equal(
            await validatorsManager.getValidators()
        );
    });

    it('insertNewValidatorFromCeremony [update own data with voting key]', async () => {
        await validatorsManager.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.insertNewValidatorFromCeremony(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: accounts[0]}
        );
        await validatorsManager.createKeys(keys1.mining, keys1.payout, keys1.voting, {from: accounts[0]});
        await validatorsManager.upsertNewValidatorFromGovernance(
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
            await validatorsManager.validator(keys1.mining)
        );

    });

    it('insertNewValidatorFromCeremony [add data with initial key]', async () => {
        await validatorsManager.addInitialKey(accounts[0], {from: systemOwner});
        "".should.be.equal(
            (await validatorsManager.validator(keys1.mining))[0]
        );
        await validatorsManager.insertNewValidatorFromCeremony(
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
            await validatorsManager.validator(keys1.mining)
        );
    });

    it('insertNewValidatorFromCeremony [fails to rewrite existing data with initial key]', async () => {
        await validatorsManager.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.insertNewValidatorFromCeremony(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: accounts[0]}
        );
        await validatorsManager.addInitialKey(accounts[4], {from: systemOwner});
        await validatorsManager.insertNewValidatorFromCeremony(
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

    it('insertNewValidatorFromCeremony [add new data with voting key]', async () => {
        await validatorsManager.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.insertNewValidatorFromCeremony(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: accounts[0]}
        );
        await validatorsManager.createKeys(keys1.mining, keys1.payout, keys1.voting, {from: accounts[0]});
        await validatorsManager.upsertNewValidatorFromGovernance(
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
            await validatorsManager.validator(keys2.mining)
        );

    });

    it('getValidator* methods', async () => {
        await validatorsManager.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.insertNewValidatorFromCeremony(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: accounts[0]}
        );
        data1.zip.should.be.bignumber.equal(
            await validatorsManager.getValidatorZip.call(keys1.mining)
        );
        data1.licenseExpiredAt.should.be.bignumber.equal(
            await validatorsManager.getValidatorLicenseExpiredAt.call(keys1.mining)
        );
        data1.licenseID.should.be.equal(
            await validatorsManager.getValidatorLicenseID.call(keys1.mining)
        );
        data1.fullName.should.be.equal(
            await validatorsManager.getValidatorFullName.call(keys1.mining)
        );
        data1.streetName.should.be.equal(
            await validatorsManager.getValidatorStreetName.call(keys1.mining)
        );
        data1.state.should.be.equal(
            await validatorsManager.getValidatorState.call(keys1.mining)
        );
        big(0).should.be.bignumber.equal(
            await validatorsManager.getValidatorDisablingDate.call(keys1.mining)
        );
    });

});
