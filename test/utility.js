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

        let bnum = await web3.eth.blockNumber;
        for(let idx=0; idx<4; idx++) {
            bnum -= 1;
            let hash = web3.eth.getBlock(bnum).hash;
            console.log('Block [' + bnum + ']: ' + hash); 
        }
        let blockNumber = await web3.eth.blockNumber;
        await utilityContract.getLastBlockHash.call();
        // check that call to method does not make testrpc mine new block
        assert.equal(blockNumber, web3.eth.blockNumber);

        let res = await utilityContract.getLastBlockHash();
        res.logs.forEach((item) => {
            console.log(item.args);
        });
        let blockHash = await web3.eth.getBlock(blockNumber).hash;
        blockHash.should.be.equal(
            await utilityContract.getLastBlockHash.call()
        );
    });

});
