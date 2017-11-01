require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;
let SimpleOwned = artifacts.require('SimpleOwned');

let {deployTestContracts} = require('./util/deploy.js');

contract('owned [all features]', function(accounts) {
    let {systemOwner, ownedContract} = {};

    beforeEach(async () => {
        ({systemOwner}  = await deployTestContracts());
        ownedContract = await SimpleOwned.new();
    });

    it('method protected by onlyOwner is avail for owner', async () => {
        true.should.be.equal(
            await ownedContract.protectedFunc.call({from: systemOwner})
        );
    });

    it('method protected by onlyOwner is restricted for non owner', async () => {
        await ownedContract.protectedFunc.call({from: accounts[0]})
            .should.be.rejectedWith('invalid opcode');
    });

});
