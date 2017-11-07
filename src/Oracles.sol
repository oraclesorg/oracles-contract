pragma solidity 0.4.18;

import "./Utility.sol";
import "./BallotsManager.sol";


/**
@title Oracles Interface
@author Oracles
*/
contract Oracles is BallotsManager {
    function Oracles() public {
        validators.push(owner);
        InitiateChange(Utility.getLastBlockHash(), validators);
    }
}
