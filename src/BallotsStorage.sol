pragma solidity 0.4.18;

import "./Owned.sol";
import "./BallotsManager.sol";
import "./KeysStorage.sol";


contract BallotsStorage is Owned {

    struct Ballot {
        address owner;
        address miningKey;
        address affectedKey;
        string memo;
        uint affectedKeyType;
        uint createdAt;
        uint votingStart;
        uint votingDeadline;
        int votesAmmount;
        int result;
        bool addAction;
        bool active;
        mapping (address => bool) voted;
    }

    mapping(uint => Ballot) public ballotsMapping;

    uint[] public ballots;

    BallotsManager public ballotsManager;
    KeysStorage public keysStorage;

    function initialize(address ballotsManagerAddr, address keysStorageAddr) public onlyOwner {
        require(msg.sender == BallotsManager(ballotsManagerAddr).owner());
        require(msg.sender == KeysStorage(keysStorageAddr).owner());

        setBallotsManager(ballotsManagerAddr);
        setKeysStorage(keysStorageAddr);
    }

    function setBallotsManager(address addr) internal {
        require(address(ballotsManager) == 0x0);
        ballotsManager = BallotsManager(addr);
    }

    function setKeysStorage(address addr) internal {
        require(address(keysStorage) == 0x0);
        require(msg.sender == KeysStorage(addr).owner());
        keysStorage = KeysStorage(addr);
    }

    function getBallotsLength() public view returns (uint value) {
        return ballots.length;
    }

    function getBallotAtPosition(uint i) public view returns (uint value) {
        return ballots[i];
    }
    
    /**
    @notice Gets active ballots' ids
    @return { "value" : "Array of active ballots ids" }
    */
    function getBallots() public view returns (uint[] value) {
        return ballots;
    }
    
    /**
    @notice Gets ballot's memo
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's memo" }
    */
    function getBallotMemo(uint ballotID) public view returns (string value) {
        return ballotsMapping[ballotID].memo;
    }
    
    /**
    @notice Gets ballot's action
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's action: adding is true, removing is false" }
    */
    function getBallotAction(uint ballotID) public view returns (bool value) {
        return ballotsMapping[ballotID].addAction;
    }
    
    /**
    @notice Gets mining key of notary
    @param ballotID Ballot unique ID
    @return { "value" : "Notary's mining key" }
    */
    function getBallotMiningKey(uint ballotID) public view returns (address value) {
        return ballotsMapping[ballotID].miningKey;
    }

    /**
    @notice Gets affected key of ballot
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's affected key" }
    */
    function getBallotAffectedKey(uint ballotID) public view returns (address value) {
        return ballotsMapping[ballotID].affectedKey;
    }

    /**
    @notice Gets affected key type of ballot
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's affected key type" }
    */
    function getBallotAffectedKeyType(uint ballotID) public view returns (uint value) {
        return ballotsMapping[ballotID].affectedKeyType;
    }

    /**
    @notice Gets ballot's owner full name
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's owner full name" }
    */
    function getBallotOwner(uint ballotID) public view returns (address value) {
        address ballotOwnerVotingKey = ballotsMapping[ballotID].owner;
        address ballotOwnerMiningKey = keysStorage.votingMiningKeysPair(ballotOwnerVotingKey);
        return ballotOwnerMiningKey;
    }
    
    /**
    @notice Gets ballot's creation time
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's creation time" }
    */
    function ballotCreatedAt(uint ballotID) public view returns (uint value) {
        return ballotsMapping[ballotID].createdAt;
    }
    
    /**
    @notice Gets ballot's voting start date
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's voting start date" }
    */
    function getBallotVotingStart(uint ballotID) public view returns (uint value) {
        return ballotsMapping[ballotID].votingStart;
    }
    
    /**
    @notice Gets ballot's voting end date
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's voting end date" }
    */
    function getBallotVotingEnd(uint ballotID) public view returns (uint value) {
        return ballotsMapping[ballotID].votingDeadline;
    }
    
    /**
    @notice Gets ballot's amount of votes for
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's amount of votes for" }
    */
    function getVotesFor(uint ballotID) public view returns (int value) {
        return (ballotsMapping[ballotID].votesAmmount + ballotsMapping[ballotID].result)/2;
    }
    
    /**
    @notice Gets ballot's amount of votes against
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's amount of votes against" }
    */
    function getVotesAgainst(uint ballotID) public view returns (int value) {
        return (ballotsMapping[ballotID].votesAmmount - ballotsMapping[ballotID].result)/2;
    }
    
    /**
    @notice Checks, if ballot is active
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's activity: active or not" }
    */
    function ballotIsActive(uint ballotID) public view returns (bool value) {
        return ballotsMapping[ballotID].active;
    }

    /**
    @notice Checks, if ballot is already voted by signer of current transaction
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot is already voted by signer of current transaction: yes or no" }
    */
    function ballotIsVoted(uint ballotID) public view returns (bool value) {
        return ballotsMapping[ballotID].voted[msg.sender];
    }
    
    /**
    @notice Votes
    @param ballotID Ballot unique ID
    @param accept Vote for is true, vote against is false
    */
    function vote(uint ballotID, bool accept) public {
        assert(keysStorage.checkVotingKeyValidity(msg.sender));
        Ballot storage v =  ballotsMapping[ballotID];
        assert(v.votingDeadline >= now);
        assert(!v.voted[msg.sender]);
        v.voted[msg.sender] = true;
        v.votesAmmount++;
        if (accept) {
            v.result++;
        } else {
            v.result--;
        }
    }

    function finalizeBallotInternal(uint ballotID) public returns(bool finalized) {
        require(msg.sender == address(ballotsManager));
        Ballot storage b = ballotsMapping[ballotID];
        if (b.votingDeadline < now && b.active) {
            if ((int(b.votesAmmount) >= int(ballotsManager.votingLowerLimit())) && b.result > 0) {
                if (b.addAction) { //add key
                    ballotsManager.checkBallotsActivityPostActionAdd(ballotID);
                } else { //invalidate key
                    ballotsManager.checkBallotsActivityPostActionRemove(ballotID);
                }
            }
            b.active = false;
            return true;
        } else {
            return false;
        }
    }

    function addBallotInternal(
        uint ballotID,
        address owner,
        address miningKey,
        address affectedKey,
        uint affectedKeyType,
        uint duration,
        bool addAction,
        string memo
    ) public {
        require(msg.sender == address(ballotsManager));
        uint votingStart = now;
        ballotsMapping[ballotID] = Ballot({
            owner: owner,
            miningKey: miningKey,
            affectedKey: affectedKey,
            memo: memo, 
            affectedKeyType: affectedKeyType,
            createdAt: now,
            votingStart: votingStart,
            votingDeadline: votingStart + duration * 1 minutes,
            votesAmmount: 0,
            result: 0,
            addAction: addAction,
            active: true
        });
        ballots.push(ballotID);
    }
}