pragma solidity 0.4.18;

import "./Owned.sol";
import "oracles-contract-key/KeyClass.sol";
import "./ValidatorsManager.sol";
import "./BallotsManager.sol";


contract KeysManager is KeyClass, Owned {
    int8 public initialKeysIssued = 0;
    int8 public initialKeysInvalidated = 0;
    int8 public initialKeysLimit = 25;
    int8 public licensesIssued = 0;
    int8 public licensesLimit = 52;

    BallotsManager public ballotsManager;
    ValidatorsManager public validatorsManager;

    function setBallotsManager(address addr) public onlyOwner {
        require(msg.sender == BallotsManager(addr).owner());
        ballotsManager = BallotsManager(addr);
    }

    function setValidatorsManager(address addr) public onlyOwner {
        require(msg.sender == ValidatorsManager(addr).owner());
        validatorsManager = ValidatorsManager(addr);
    }
    
    /**
    @notice Adds initial key
    @param key Initial key
    */
    function addInitialKey(address key) public onlyOwner {
        assert(initialKeysIssued < initialKeysLimit);
        // Check that key has not been added already
        assert(!initialKeys[key].isNew);
        initialKeysIssued++;
        initialKeys[key] = InitialKey({isNew: true});
    }
    
    /**
    @notice Create production keys for notary
    @param miningAddr Mining key
    @param payoutAddr Payout key
    @param votingAddr Voting key
    */
    function createKeys(
        address miningAddr, 
        address payoutAddr, 
        address votingAddr
    ) public {
        assert(checkInitialKey(msg.sender));
        //invalidate initial key
        delete initialKeys[msg.sender];
        miningKeys[miningAddr] = MiningKey({isActive: true});
        payoutKeys[payoutAddr] = PayoutKey({isActive: true});
        votingKeys[votingAddr] = VotingKey({isActive: true});
        initialKeysInvalidated++;
        licensesIssued++;
        //add mining key to list of validators
        validatorsManager.addValidator(miningAddr);
        votingMiningKeysPair[votingAddr] = miningAddr;
        miningPayoutKeysPair[miningAddr] = payoutAddr;
    }
    
    /**
    @notice Checks, if initial key is new or not
    @param key Initial key
    @return { "value" : "Is initial key new or not new" }
    */
    function checkInitialKey(address key) public view returns (bool value) {
        // Next line is disabled because it does not make sense
        //assert(msg.sender == key);
        return initialKeys[key].isNew;
    }
    
    /**
    @notice Checks, if payout key is active or not
    @param addr Payout key
    @return { "value" : "Is payout key active or not active" }
    */
    function checkPayoutKeyValidity(address addr) public view returns (bool value) {
        return payoutKeys[addr].isActive;
    }
    
    /**
    @notice Checks, if voting key is active or not
    @param addr Voting key
    @return { "value" : "Is voting key active or not active" }
    */
    function checkVotingKeyValidity(address addr) public view returns (bool value) {
        return votingKeys[addr].isActive;
    }

    function increaseLicenses() public {
        require(msg.sender == address(ballotsManager));
        licensesIssued++;
    }

    function setVotingKey(address _votingKey, bool _isActive) public {
        require(msg.sender == address(ballotsManager));
        votingKeys[_votingKey] = VotingKey({isActive: _isActive});

    }

    function setPayoutKey(address _payoutKey, bool _isActive) public {
        require(msg.sender == address(ballotsManager));
        payoutKeys[_payoutKey] = PayoutKey({isActive: _isActive});
    }

    function setMiningPayoutKeysPair(address miningKey, address payoutKey) public {
        require(msg.sender == address(ballotsManager));
        miningPayoutKeysPair[miningKey] = payoutKey;
    }

    function setVotingMiningKeysPair(address votingKey, address miningKey) public {
        require(msg.sender == address(ballotsManager));
        votingMiningKeysPair[votingKey] = miningKey;
    }
}
