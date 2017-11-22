pragma solidity 0.4.18;

import "./../Utility.sol";
import "./../ValidatorsStorage.sol";


contract ValidatorsStorageProxy is ValidatorsStorage {
    function ValidatorsStorageProxy() public ValidatorsStorage() {
        // ValidatorsStorage constructor puts `ValidatorsStorage.owner`
        // into `validators` list
        // We need to remove it first, then add custom test owner value
        // into the list
        owner = 0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0;
        // At this point `validators` contains only one element;
        validators.length--;
        validators.push(owner);
        InitiateChange(Utility.getLastBlockHash(), validators);
    }

}
