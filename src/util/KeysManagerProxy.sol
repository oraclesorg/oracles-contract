import './../KeysManager.sol';

contract KeysManagerProxy is KeysManager {
    function KeysManagerProxy() public KeysManager() {
        owner = 0x338a7867a35367d120011b2da1d8e2a8a60b9bc0;
    }

    function getInitialKeysIssued() public view returns (int8) {
        return initialKeysIssued;
    }

    function getLicensesIssued() public view returns (int8) {
        return licensesIssued;
    }
}
