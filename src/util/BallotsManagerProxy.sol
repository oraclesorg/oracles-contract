pragma solidity 0.4.18;

import "./../BallotsManager.sol";


contract BallotsManagerProxy is BallotsManager {
    function BallotsManagerProxy() public BallotsManager() {
        owner = 0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0;
    }

    function callIncreaseLicenses() public {
        keysStorage.increaseLicenses();
    }

    function callSetVotingMiningKeysPair(address votingKey, address miningKey) public {
        keysStorage.setVotingMiningKeysPair(votingKey, miningKey);
    }

    function callSetMiningVotingKeysPair(address miningKey, address votingKey) public {
        keysStorage.setMiningVotingKeysPair(miningKey, votingKey);
    }

    function callSetMiningPayoutKeysPair(address miningKey, address payoutKey) public {
        keysStorage.setMiningPayoutKeysPair(miningKey, payoutKey);
    }

    function callSetVotingKey(address _votingKey, bool _isActive) public {
        keysStorage.setVotingKey(_votingKey, _isActive);
    }

    function callSetPayoutKey(address _payoutKey, bool _isActive) public {
        keysStorage.setPayoutKey(_payoutKey, _isActive);
    }

}
