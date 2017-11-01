pragma solidity ^0.4.14;

contract Utility {
    event Block(uint256 number, bytes32 hash);

	function getLastBlockHash() public view returns (bytes32) {
	    uint256 lastBlockNumber = block.number - 1;
	    bytes32 lastBlockHash = block.blockhash(lastBlockNumber);
        Block(lastBlockNumber, lastBlockHash);
	    return lastBlockHash;
	}

}
