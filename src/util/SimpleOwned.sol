pragma solidity ^0.4.15;

import './../Owned.sol';

contract SimpleOwned is Owned {
    function protectedFunc() public view onlyOwner returns (bool) {
        return true;
    }
}
