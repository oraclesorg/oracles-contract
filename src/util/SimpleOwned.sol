pragma solidity ^0.4.15;

import './../owned.sol';

contract SimpleOwned is owned {
    function protectedFunc() onlyOwner returns (bool) {
        return true;
    }
}
