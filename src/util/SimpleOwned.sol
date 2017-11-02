pragma solidity ^0.4.15;

import './../Owned.sol';

contract SimpleOwned is Owned {
    function SimpleOwned() public Owned() {
        owner = 0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0;
    }

    function protectedFunc() public view onlyOwner returns (bool) {
        return true;
    }
}
