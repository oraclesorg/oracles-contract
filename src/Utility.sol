pragma solidity ^0.4.18;// solhint-disable-line compiler-fixed, compiler-gt-0_4


contract Utility {
    function getLastBlockHash() public view returns (bytes32) {
        uint256 lastBlockNumber = block.number - 1;
        bytes32 lastBlockHash = block.blockhash(lastBlockNumber);
        return lastBlockHash;
    }
}