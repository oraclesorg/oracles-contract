pragma solidity ^0.4.14;

import "./Owned.sol";
import "./Utility.sol";
import "oracles-contract-key/KeyClass.sol";
import "oracles-contract-validator/ValidatorClass.sol";
import "oracles-contract-ballot/BallotClass.sol";

contract KeysManager is Owned, Utility, KeyClass, ValidatorClass, BallotClass {
    int8 internal initialKeysIssued = 0;
    int8 internal initialKeysLimit = 25;
    int8 internal licensesIssued = 0;
    int8 internal licensesLimit = 52;
    
    /**
    @notice Adds initial key
    @param key Initial key
    */
    function addInitialKey(address key) onlyOwner {
        assert(initialKeysIssued < initialKeysLimit);
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
    ) {
        assert(checkInitialKey(msg.sender));
        //invalidate initial key
        delete initialKeys[msg.sender];
        miningKeys[miningAddr] = MiningKey({isActive: true});
        payoutKeys[payoutAddr] = PayoutKey({isActive: true});
        votingKeys[votingAddr] = VotingKey({isActive: true});
        //add mining key to list of validators
        licensesIssued++;
        validators.push(miningAddr);
        InitiateChange(Utility.getLastBlockHash(), validators);
        votingMiningKeysPair[votingAddr] = miningAddr;
        miningPayoutKeysPair[miningAddr] = payoutAddr;
    }
    
    /**
    @notice Checks, if initial key is new or not
    @param key Initial key
    @return { "value" : "Is initial key new or not new" }
    */
    function checkInitialKey(address key) constant returns (bool value) {
        assert(msg.sender == key);
        return initialKeys[key].isNew;
    }
    
    /**
    @notice Checks, if payout key is active or not
    @param addr Payout key
    @return { "value" : "Is payout key active or not active" }
    */
    function checkPayoutKeyValidity(address addr) constant returns (bool value) {
        return payoutKeys[addr].isActive;
    }
    
    /**
    @notice Checks, if voting key is active or not
    @param addr Voting key
    @return { "value" : "Is voting key active or not active" }
    */
    function checkVotingKeyValidity(address addr) constant returns (bool value) {
        return votingKeys[addr].isActive;
    }
}
