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

    it('getLastBlockHash', async () => {
        let blockNumber = await web3.eth.blockNumber;
        await utilityContract.getLastBlockHash.call();
        // check that call to method does not make testrpc mine new block
        assert.equal(blockNumber, web3.eth.blockNumber);

        let blockHash = await web3.eth.getBlock(blockNumber - 1).hash;
        blockHash.should.be.equal(
            await utilityContract.getLastBlockHash.call()
        );
    });

});
0xdf5f2a35fbea90ec4218ccf880bef3f1e9febe60c9fabc5ddf0e177273195731
0xd2f8f61201b2b11a78d6e866abc9c3db2ae8631fa656bfe5cb53668255367afb
