pragma solidity ^0.4.15;

import './../owned.sol';

contract SimpleOwned is owned {
    function protectedFunc() public view onlyOwner returns (bool) {
        return true;
    }
}
