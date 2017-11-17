pragma solidity 0.4.18;

import "./Owned.sol";
import "./Utility.sol";
import "oracles-contract-ballot/BallotClass.sol";
import "./KeysManager.sol";
import "./ValidatorsStorage.sol";
import "./ValidatorsManager.sol";


contract BallotsManager is BallotClass, Utility, Owned {

    KeysStorage public keysStorage;
    KeysManager public keysManager;
    ValidatorsStorage public validatorsStorage;
    ValidatorsManager public validatorsManager;

    function initialize(address keysStorageAddr, address keysManagerAddr, address validatorsStorageAddr, address validatorsManagerAddr) public onlyOwner {
        require(msg.sender == ValidatorsStorage(validatorsStorageAddr).owner());
        require(msg.sender == ValidatorsManager(validatorsManagerAddr).owner());
        require(msg.sender == KeysStorage(keysStorageAddr).owner());
        require(msg.sender == KeysManager(keysManagerAddr).owner());

        setKeysStorage(keysStorageAddr);
        setKeysManager(keysManagerAddr);
        setValidatorsStorage(validatorsStorageAddr);
        setValidatorsManager(validatorsManagerAddr);
    }

    function setValidatorsStorage(address addr) internal {
        require(address(validatorsStorage) == 0x0);
        validatorsStorage = ValidatorsStorage(addr);
    }

    function setValidatorsManager(address addr) internal {
        require(address(validatorsManager) == 0x0);
        validatorsManager = ValidatorsManager(addr);
    }

    function setKeysStorage(address addr) public onlyOwner {
        require(address(keysStorage) == 0x0);
        require(msg.sender == KeysStorage(addr).owner());
        keysStorage = KeysStorage(addr);
    }

    function setKeysManager(address addr) internal {
        require(address(keysManager) == 0x0);
        keysManager = KeysManager(addr);
    }

    /**
    @notice Adds new Ballot
    @param ballotID Ballot unique ID
    @param owner Voting key of notary, who creates ballot
    @param miningKey Mining key of notary, which is proposed to add or remove
    @param affectedKey Mining/payout/voting key of notary, which is proposed to add or remove
    @param affectedKeyType Type of affectedKey: 0 = mining key, 1 = voting key, 2 = payout key
    @param duration Duration of ballot in minutes
    @param addAction Flag: adding is true, removing is false
    @param memo Ballot's memo
    */
    function addBallot(
        uint ballotID,
        address owner,
        address miningKey,
        address affectedKey,
        uint affectedKeyType,
        uint duration,
        bool addAction,
        string memo
    ) public {
        assert(keysStorage.checkVotingKeyValidity(msg.sender));
        assert(!(keysStorage.licensesIssued() == keysManager.licensesLimit() && addAction));
        assert(ballotsMapping[ballotID].createdAt <= 0);
        if (affectedKeyType == 0) {//mining key
            bool validatorIsAdded = false;
            uint validatorLength = validatorsStorage.getValidatorsLength();
            for (uint i = 0; i < validatorLength; i++) {
                assert(!(validatorsStorage.getValidatorAtPosition(i) == affectedKey && addAction)); //validator is already added before
                if (validatorsStorage.getValidatorAtPosition(i) == affectedKey) {
                    validatorIsAdded = true;
                    break;
                }
            }
            uint disabledValidatorsLength = validatorsStorage.getDisabledValidatorsLength();
            for (uint j = 0; j < disabledValidatorsLength; j++) {
                assert(validatorsStorage.getDisabledValidatorAtPosition(j) != affectedKey); //validator is already removed before
            }
            assert(!(!validatorIsAdded && !addAction)); // no such validator in validators array to remove it
        } else if (affectedKeyType == 1) {//voting key
            assert(!(keysStorage.checkVotingKeyValidity(affectedKey) && addAction)); //voting key is already added before
            assert(!(!keysStorage.checkVotingKeyValidity(affectedKey) && !addAction)); //no such voting key to remove it
        } else if (affectedKeyType == 2) {//payout key
            assert(!(keysStorage.checkPayoutKeyValidity(affectedKey) && addAction)); //payout key is already added before
            assert(!(!keysStorage.checkPayoutKeyValidity(affectedKey) && !addAction)); //no such payout key to remove it
        }
        addBallotInternal(ballotID, owner, miningKey, affectedKey, affectedKeyType, duration, addAction, memo);
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
    ) internal {
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

    /**
    @notice Finalizes ballot
    @dev Finalizes ballot
    */
    function finalizeBallot(uint ballotID) public {
        assert(keysStorage.checkVotingKeyValidity(msg.sender));
        if (!finalizeBallotInternal(ballotsMapping[ballotID])) {
            checkBallotsActivity();
        }
    }

    function finalizeBallotInternal(Ballot b) internal returns(bool finalized) {
        if (b.votingDeadline < now && b.active) {
            if ((int(b.votesAmmount) >= int(votingLowerLimit)) && b.result > 0) {
                if (b.addAction) { //add key
                    checkBallotsActivityPostActionAdd(b);
                } else { //invalidate key
                    checkBallotsActivityPostActionRemove(b);
                }
            }
            b.active = false;
            return true;
        } else {
            return false;
        }
    }

    /**
    @notice Checks ballots' activity
    @dev Deactivate ballots, if ballot's time is finished and 
    implement action: add or remove notary, if votes for are 
    greater votes against, and total votes are greater than 3
    */
    function checkBallotsActivity() internal {
        for (uint ijk = 0; ijk < ballots.length; ijk++) {
            finalizeBallotInternal(ballotsMapping[ballots[ijk]]);
        }
    }

    function checkBallotsActivityPostActionAdd(Ballot b) internal {
        if (b.affectedKeyType == 0) {//mining key
            if (keysStorage.licensesIssued() < keysManager.licensesLimit()) {
                keysStorage.increaseLicenses();
                validatorsStorage.addValidator(b.affectedKey);
            }
        } else if (b.affectedKeyType == 1) {//voting key
            keysStorage.setVotingKey(b.affectedKey, true);
            keysStorage.setVotingMiningKeysPair(b.affectedKey, b.miningKey);
        } else if (b.affectedKeyType == 2) {//payout key
            keysStorage.setPayoutKey(b.affectedKey, true);
            keysStorage.setMiningPayoutKeysPair(b.miningKey, b.affectedKey);
        }
    }

    function checkBallotsActivityPostActionRemove(Ballot b) internal {
        if (b.affectedKeyType == 0) {//mining key
            uint validatorLength = validatorsStorage.getValidatorsLength();
            for (uint jj = 0; jj < validatorLength; jj++) {
                if (validatorsStorage.getValidatorAtPosition(jj) == b.affectedKey) {
                    validatorsStorage.removeValidator(jj); 
                    return;
                }
            }
            validatorsStorage.disableValidator(b.affectedKey);
        } else if (b.affectedKeyType == 1) {//voting key
            keysStorage.setVotingKey(b.affectedKey, false);
        } else if (b.affectedKeyType == 2) {//payout key
            keysStorage.setPayoutKey(b.affectedKey, false);
        }
    }
}