pragma solidity ^0.4.18;// solhint-disable-line compiler-fixed, compiler-gt-0_4

import "./../KeysManager.sol";


contract KeysManagerProxy is KeysManager {
    function KeysManagerProxy() public KeysManager() {
        owner = 0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0;
    }

    function getInitialKeysIssued() public view returns (int8) {
        return initialKeysIssued;
    }

    function getLicensesIssued() public view returns (int8) {
        return licensesIssued;
    }
}
