pragma solidity 0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./Owned.sol";
import "./KeysManager.sol";
import "./ValidatorsStorage.sol";
import "./ValidatorsManager.sol";
import "./BallotsManager.sol";

contract KeysStorage is Owned {
    using SafeMath for uint256;

    int8 public initialKeysIssued = 0;
    int8 public initialKeysInvalidated = 0;
    int8 public licensesIssued = 0;
    
    struct InitialKey {
        bool isNew;
    }
   
    struct MiningKey {
        bool isActive;
    }
    
    struct PayoutKey {
        bool isActive;
    }

    struct VotingKey {
        bool isActive;
    }

    struct SecondaryKeys {
        address votingKey;
        address payoutKey;
    }
    
    mapping(address => MiningKey) public miningKeys;
    mapping(address => PayoutKey) public payoutKeys;
    mapping(address => VotingKey) public votingKeys;
    mapping(address => InitialKey) public initialKeys;
    mapping(address => address) public votingMiningKeysPair;
    mapping(address => SecondaryKeys) public miningToSecondaryKeys;

    KeysManager public keysManager;
    BallotsManager public ballotsManager;
    ValidatorsStorage public validatorsStorage;
    ValidatorsManager public validatorsManager;
    
    function initialize(address keysManagerAddr, address ballotsManagerAddr, address validatorsStorageAddr, address validatorsManagerAddr) public onlyOwner {
        require(msg.sender == KeysManager(keysManagerAddr).owner());
        require(msg.sender == BallotsManager(ballotsManagerAddr).owner());
        require(msg.sender == ValidatorsStorage(validatorsStorageAddr).owner());
        require(msg.sender == ValidatorsManager(validatorsManagerAddr).owner());
        setKeysManager(keysManagerAddr);
        setBallotsManager(ballotsManagerAddr);
        setValidatorsStorage(validatorsStorageAddr);
        setValidatorsManager(validatorsManagerAddr);
    }

    function setKeysManager(address addr) internal {
        require(address(keysManager) == 0x0);
        keysManager = KeysManager(addr);
    }

    function setBallotsManager(address addr) internal {
        require(address(ballotsManager) == 0x0);
        ballotsManager = BallotsManager(addr);
    }

    function setValidatorsStorage(address addr) internal {
        require(address(validatorsStorage) == 0x0);
        validatorsStorage = ValidatorsStorage(addr);
    }

    function setValidatorsManager(address addr) internal {
        require(address(validatorsManager) == 0x0);
        validatorsManager = ValidatorsManager(addr);
    }

    /**
    @notice Adds initial key
    @param key Initial key
    */
    function addInitialKey(address key) public onlyOwner {
        assert(initialKeysIssued < keysManager.initialKeysLimit());
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
        validatorsStorage.addValidator(miningAddr);
        votingMiningKeysPair[votingAddr] = miningAddr;
        miningToSecondaryKeys[miningAddr] = SecondaryKeys({votingKey: votingAddr, payoutKey: payoutAddr});
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
    @notice Checks, if mining key is active or not
    @param addr Mining key
    @return { "value" : "Is mining key active or not active" }
    */
    function checkMiningKeyValidity(address addr) public view returns (bool value) {
        return miningKeys[addr].isActive;
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
        miningToSecondaryKeys[miningKey] = SecondaryKeys({votingKey: miningToSecondaryKeys[miningKey].votingKey, payoutKey: payoutKey});
    }

    function setMiningVotingKeysPair(address miningKey, address votingKey) public {
        require(msg.sender == address(ballotsManager));
        miningToSecondaryKeys[miningKey] = SecondaryKeys({votingKey: votingKey, payoutKey: miningToSecondaryKeys[miningKey].payoutKey});
    }

    function getVotingByMining(address miningKey) public view returns (address votingKey) {
        return miningToSecondaryKeys[miningKey].votingKey;
    }

    function getPayoutByMining(address miningKey) public view returns (address payoutKey) {
        return miningToSecondaryKeys[miningKey].payoutKey;
    }

    function setVotingMiningKeysPair(address votingKey, address miningKey) public {
        require(msg.sender == address(ballotsManager));
        votingMiningKeysPair[votingKey] = miningKey;
    }

    function getMiningByVoting(address votingKey) public view returns (address miningKey) {
        return votingMiningKeysPair[votingKey];
    }

    function getLicensesIssuedFromGovernance() public view returns (uint licensesIssuedFromGovernance) {
        return SafeMath.sub(uint(licensesIssued), uint(initialKeysInvalidated));
    }
}
