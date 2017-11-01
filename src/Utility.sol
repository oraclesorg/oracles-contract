pragma solidity ^0.4.14;

contract Utility {
	function getLastBlockHash() returns (bytes32 _blockHash) {
	    uint256 lastBlockNumber = block.number - 1;
	    bytes32 lastBlockHash = bytes32(block.blockhash(lastBlockNumber));
	    return lastBlockHash;
	}
}
