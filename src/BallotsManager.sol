pragma solidity ^0.4.11;

import "oracles-demo-data/DemoData.sol";
import "./ValidatorsManager.sol";

contract BallotsManager is ValidatorsManager, DemoData {
    /**
    @notice Adds new Ballot
    @param ballotID Ballot unique ID
    @param miningKey Mining key of notary which is proposed to add or remove
    @param addAction Flag: adding is true, removing is false
    @param memo Ballot's memo
    */
    function addBallot(
        uint ballotID,
        address miningKey,
        bool addAction,
        string memo
    ) {
        if (!checkVotingKeyValidity(msg.sender)) throw;
        if (licensesIssued == licensesLimit && addAction) throw;
        bool validatorIsAdded = false;
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i] == miningKey && addAction) throw; //validator is already added before
            if (validators[i] == miningKey) {
                validatorIsAdded = true;
                break;
            }
        }
        bool disabledValidatorIsAdded = false;
        for (uint j = 0; j < disabledValidators.length; j++) {
            if (disabledValidators[j] == miningKey) throw; //validator is already removed before
        }
        if (!validatorIsAdded && !addAction) throw; // no such validator in validators array to remove it
        uint votingStart = now;
        ballotsMapping[ballotID] = Ballot({
            owner: msg.sender,
            miningKey: miningKey,
            memo: memo, 
            createdAt: now,
            votingStart: votingStart,
            votingDeadline: votingStart + 5 * 1 minutes,
            votesAmmount: 0,
            result: 0,
            addAction: addAction,
            active: true
        });
        ballots.push(ballotID);
        checkBallotsActivity();
    }
    
    /**
    @notice Gets active ballots' ids
    @return { "value" : "Array of active ballots ids" }
    */
    function getBallots() constant returns (uint[] value) {
        return ballots;
    }
    
    /**
    @notice Gets ballot's memo
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's memo" }
    */
    function getBallotMemo(uint ballotID) constant returns (string value) {
        return ballotsMapping[ballotID].memo;
    }
    
    /**
    @notice Gets ballot's action
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's action: adding is true, removing is false" }
    */
    function getBallotAction(uint ballotID) constant returns (bool value) {
        return ballotsMapping[ballotID].addAction;
    }
    
    /**
    @notice Gets mining key of notary
    @param ballotID Ballot unique ID
    @return { "value" : "Mining key of notary" }
    */
    function getBallotMiningKey(uint ballotID) constant returns (address value) {
        return ballotsMapping[ballotID].miningKey;
    }

    /**
    @notice Gets ballot's owner full name
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's owner full name" }
    */
    function getBallotOwner(uint ballotID) constant returns (string value) {
        return validator[ballotsMapping[ballotID].owner].fullName;
    }
    
    /**
    @notice Gets ballot's creation time
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's creation time" }
    */
    function ballotCreatedAt(uint ballotID) constant returns (uint value) {
        return ballotsMapping[ballotID].createdAt;
    }
    
    /**
    @notice Gets ballot's voting start date
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's voting start date" }
    */
    function getBallotVotingStart(uint ballotID) constant returns (uint value) {
        return ballotsMapping[ballotID].votingStart;
    }
    
    /**
    @notice Gets ballot's voting end date
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's voting end date" }
    */
    function getBallotVotingEnd(uint ballotID) constant returns (uint value) {
        return ballotsMapping[ballotID].votingDeadline;
    }
    
    /**
    @notice Gets ballot's amount of votes for
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's amount of votes for" }
    */
    function getVotesFor(uint ballotID) constant returns (int value) {
        return (ballotsMapping[ballotID].votesAmmount + ballotsMapping[ballotID].result)/2;
    }
    
    /**
    @notice Gets ballot's amount of votes against
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's amount of votes against" }
    */
    function getVotesAgainst(uint ballotID) constant returns (int value) {
        return (ballotsMapping[ballotID].votesAmmount - ballotsMapping[ballotID].result)/2;
    }
    
    /**
    @notice Checks, if ballot is active
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot's activity: active or not" }
    */
    function ballotIsActive(uint ballotID) constant returns (bool value) {
        return ballotsMapping[ballotID].active;
    }

    /**
    @notice Checks, if ballot is already voted by signer of current transaction
    @param ballotID Ballot unique ID
    @return { "value" : "Ballot is already voted by signer of current transaction: yes or no" }
    */
    function ballotIsVoted(uint ballotID) constant returns (bool value) {
        return ballotsMapping[ballotID].voted[msg.sender];
    }
    
    /**
    @notice Votes
    @param ballotID Ballot unique ID
    @param accept Vote for is true, vote against is false
    */
    function vote(uint ballotID, bool accept) {
        if (!checkVotingKeyValidity(msg.sender)) throw;
        Ballot v =  ballotsMapping[ballotID];
        if (v.votingDeadline < now) throw;
        if (v.voted[msg.sender] == true) throw;
        v.voted[msg.sender] = true;
        v.votesAmmount++;
        if (accept) v.result++;
        else v.result--;
        checkBallotsActivity();
    }
    
    /**
    @notice Checks ballots' activity
    @dev Deactivate ballots, if ballot's time is finished and implement action: add or remove notary, if votes for are greater votes against, and total votes are greater than 3
    */
    function checkBallotsActivity() internal {
        for (uint ijk = 0; ijk < ballots.length; ijk++) {
            Ballot b = ballotsMapping[ballots[ijk]];
            if (b.votingDeadline < now && b.active) {
                if ((int(b.votesAmmount) >= int(votingLowerLimit)) && b.result > 0) {
                    if (b.addAction) {
                        if (licensesIssued < licensesLimit) {
                            licensesIssued++;
                            validators.push(b.miningKey);
                        }
                    } else {
                        for (uint jj = 0; jj < validators.length; jj++) {
                            if (validators[jj] == b.miningKey && b.result > 0) {
                                validators = remove(validators, jj); 
                                return;
                            }
                        }
                        disabledValidators.push(b.miningKey);
                        validator[b.miningKey].disablingDate = now;
                    }
                }
                b.active = false;
            }
        }
    }
}