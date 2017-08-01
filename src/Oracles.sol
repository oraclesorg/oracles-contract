pragma solidity ^0.4.14;

import "./Utility.sol";
import "./BallotsManager.sol";

/**
@title Oracles Interface
@author Oracles
*/
contract Oracles is BallotsManager {
	function Oracles() {
		validators.push(owner);
		InitiateChange(Utility.getLastBlockHash(), validators);
	}
}