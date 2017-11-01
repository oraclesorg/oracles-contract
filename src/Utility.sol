pragma solidity ^0.4.14;

contract Utility {
	function getLastBlockHash() public view returns (bytes32) {
	    uint256 lastBlockNumber = block.number - 1;
	    bytes32 lastBlockHash = block.blockhash(lastBlockNumber);
	    return lastBlockHash;
	}

}
