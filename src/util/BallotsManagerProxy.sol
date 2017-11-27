pragma solidity 0.4.18;

import "./../BallotsManager.sol";


contract BallotsManagerProxy is BallotsManager {
    function BallotsManagerProxy() public BallotsManager() {
        owner = 0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0;
    }

    function callKeysStorageIncreaseLicenses() public {
        keysStorage.increaseLicenses();
    }

}
