require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let sprintf = require('sprintf');
let {addressFromNumber} = require('./util/ether.js');

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
        zip: 644081,
        licenseExpiredAt: 1893456000, // 2030 year
        licenseID: 'license-1',
        fullName: 'Ivan Ivanov',
        streetName: 'Elm Street',
        state: 'Ohio',
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

    it('addValidator updates `.validator` mapping', async () => {
        await validatorsManager.addInitialKey(accounts[0], {from: systemOwner});
        await validatorsManager.createKeys(keys1.mining, keys1.payout, keys1.voting, {from: accounts[0]});
        await validatorsManager.addValidator(
            keys1.mining,
            data1.zip,
            data1.licenseExpiredAt,
            data1.licenseID,
            data1.fullName,
            data1.streetName,
            data1.state,
            {from: keys1.voting}
        );
        [
            data1.fullName, data1.streetName, data1.state, big(data1.zip),
            data1.licenseID, big(data1.licenseExpiredAt), big(0), ""
        ].should.be.deep.equal(
            await validatorsManager.validator(keys1.mining)
        );

    });
});
