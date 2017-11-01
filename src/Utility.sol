pragma solidity ^0.4.14;

contract Utility {
    event Block(uint256 number, bytes32 hash);

	function getLastBlockHash() returns (bytes32) {
	    uint256 lastBlockNumber = block.number - 1;
	    bytes32 lastBlockHash = block.blockhash(lastBlockNumber);

        Block(0, lastBlockHash);
        Block(block.number - 1, block.blockhash(block.number - 1));
        Block(block.number - 2 , block.blockhash(block.number - 2));
        Block(block.number - 3, block.blockhash(block.number - 3));
        Block(block.number - 4, block.blockhash(block.number - 4));

	    return lastBlockHash;
	}
}
