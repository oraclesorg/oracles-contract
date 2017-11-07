require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();
let data = require('./data.js');
let big = require('./util/bigNum.js').big;

let {deployTestContracts} = require('./util/deploy.js');

contract('Utility [all features]', function(accounts) {
    let {utilityContract} = {};

    beforeEach(async () => {
        ({utilityContract} = await deployTestContracts());
    });

    // DOES NOT WORK :(
    //it('getLastBlockHash', async () => {
    //    // force block mining
    //    await utilityContract.getLastBlockHash();

    //    let prevBlockNumber = await web3.eth.blockNumber - 1;
    //    let prevBlockHash = await web3.eth.getBlock(prevBlockNumber).hash;

    //    prevBlockHash.should.be.equal(
    //        await utilityContract.getLastBlockHash.call()
    //    );
    //});

});
