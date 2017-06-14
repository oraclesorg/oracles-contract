pragma solidity ^0.4.11;

import "./owned.sol";
import "oracles-key/KeyClass.sol";
import "oracles-validator/ValidatorClass.sol";
import "oracles-ballot/BallotClass.sol";

contract KeysManager is owned, KeyClass, ValidatorClass, BallotClass {
    int8 internal initialKeysIssued = 0;
    int8 internal initialKeysLimit = 12;
    int8 internal licensesIssued = 0;
    int8 internal licensesLimit = 52;
    
    /**
    @notice Adds initial key
    @param key Initial key
    */
    function addInitialKey(address key) onlyOwner {
        if (initialKeysIssued >= initialKeysLimit) throw;
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
        if (!checkInitialKey(msg.sender)) throw;
        //invalidate initial key
        delete initialKeys[msg.sender];
        miningKeys[miningAddr] = MiningKey({isActive: true});
        payoutKeys[payoutAddr] = PayoutKey({isActive: true});
        votingKeys[votingAddr] = VotingKey({isActive: true});
        //add mining key to list of validators
        licensesIssued++;
        validators.push(miningAddr);
    }

    /**
    @notice Removes element by index from array and shift elements in array
    @param array Array to change
    @param index Element's index to remove
    @return { "value" : "Updated array with removed element at index" }
    */
    function remove(address[] array, uint index) internal returns(address[] value) {
        if (index >= array.length) return;

        address[] memory arrayNew = new address[](array.length-1);
        for (uint i = 0; i<arrayNew.length; i++){
            if(i != index && i<index){
                arrayNew[i] = array[i];
            } else {
                arrayNew[i] = array[i+1];
            }
        }
        delete array;
        return arrayNew;
    }
    
    /**
    @notice Checks, if initial key is new or not
    @param key Initial key
    @return { "value" : "Is initial key new or not new" }
    */
    function checkInitialKey(address key) constant returns (bool value) {
        if (msg.sender != key) throw;
        return initialKeys[key].isNew;
    }
    
    /**
    @notice Checks, if payout key is active or not
    @param addr Payout key
    @return { "value" : "Is payout key active or not active" }
    */
    function checkPayoutKeyValidity(address addr) constant returns (bool value) {
        //if (msg.sender != addr) throw;
        return payoutKeys[addr].isActive;
    }
    
    /**
    @notice Checks, if voting key is active or not
    @param addr Voting key
    @return { "value" : "Is voting key active or not active" }
    */
    function checkVotingKeyValidity(address addr) constant returns (bool value) {
        //if (msg.sender != addr) throw;
        return votingKeys[addr].isActive;
    }
}