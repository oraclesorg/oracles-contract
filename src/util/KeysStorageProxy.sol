pragma solidity 0.4.18;

import "./../KeysStorage.sol";


contract KeysStorageProxy is KeysStorage {
    function KeysStorageProxy() public KeysStorage() {
        owner = 0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0;
    }

}
