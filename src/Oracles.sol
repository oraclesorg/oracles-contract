pragma solidity ^0.4.18;// solhint-disable-line compiler-fixed, compiler-gt-0_4

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
