pragma solidity 0.4.18;


contract Utility {
    function getLastBlockHash() public view returns (bytes32) {
        uint256 lastBlockNumber = block.number - 1;
        bytes32 lastBlockHash = block.blockhash(lastBlockNumber);
        return lastBlockHash;
    }

    function toString(address x) public pure returns (string) {
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        return string(b);
    }
}