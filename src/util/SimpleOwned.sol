pragma solidity ^0.4.15;

import './../Owned.sol';

contract SimpleOwned is Owned {
    function SimpleOwned() public Owned() {
        owner = 0x338a7867a35367d120011b2da1d8e2a8a60b9bc0;
    }

    function protectedFunc() public view onlyOwner returns (bool) {
        return true;
    }
}
