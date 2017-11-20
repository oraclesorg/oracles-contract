pragma solidity 0.4.18;

import "./Owned.sol";
import "./BallotsStorage.sol";
import "./KeysStorage.sol";
import "./KeysManager.sol";
import "./ValidatorsStorage.sol";


contract BallotsManager is Owned {
    uint public votingLowerLimit = 3;

    BallotsStorage public ballotsStorage;
    KeysStorage public keysStorage;
    KeysManager public keysManager;
    ValidatorsStorage public validatorsStorage;

    function initialize(address ballotsStorageAddr, address keysStorageAddr, address keysManagerAddr, address validatorsStorageAddr) public onlyOwner {
        require(msg.sender == BallotsStorage(ballotsStorageAddr).owner());
        require(msg.sender == ValidatorsStorage(validatorsStorageAddr).owner());
        require(msg.sender == KeysStorage(keysStorageAddr).owner());
        require(msg.sender == KeysManager(keysManagerAddr).owner());

        setBallotsStorage(ballotsStorageAddr);
        setKeysStorage(keysStorageAddr);
        setKeysManager(keysManagerAddr);
        setValidatorsStorage(validatorsStorageAddr);
    }

    function setBallotsStorage(address addr) internal {
        require(address(ballotsStorage) == 0x0);
        ballotsStorage = BallotsStorage(addr);
    }

    function setValidatorsStorage(address addr) internal {
        require(address(validatorsStorage) == 0x0);
        validatorsStorage = ValidatorsStorage(addr);
    }

    function setKeysStorage(address addr) internal {
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
        assert(!(keysStorage.getLicensesIssuedFromGovernance() == keysManager.getLicensesLimitFromGovernance() && addAction));
        assert(ballotsStorage.ballotCreatedAt(ballotID) <= 0);
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
        ballotsStorage.addBallotInternal(ballotID, owner, miningKey, affectedKey, affectedKeyType, duration, addAction, memo);
    }

    /**
    @notice Finalizes ballot
    @dev Finalizes ballot
    */
    function finalizeBallot(uint ballotID) public {
        assert(keysStorage.checkVotingKeyValidity(msg.sender));
        if (!ballotsStorage.finalizeBallotInternal(ballotID)) {
            checkBallotsActivity();
        }
    }

    /**
    @notice Checks ballots' activity
    @dev Deactivate ballots, if ballot's time is finished and 
    implement action: add or remove notary, if votes for are 
    greater votes against, and total votes are greater than 3
    */
    function checkBallotsActivity() internal {
        for (uint ijk = 0; ijk < ballotsStorage.getBallotsLength(); ijk++) {
            uint ballotID = ballotsStorage.getBallotAtPosition(ijk);
            ballotsStorage.finalizeBallotInternal(ballotID);
        }
    }

    function checkBallotsActivityPostActionAdd(uint ballotID) public {
        require(msg.sender == address(ballotsStorage));
        address affectedKey = ballotsStorage.getBallotAffectedKey(ballotID);
        address miningKey = ballotsStorage.getBallotMiningKey(ballotID);
        uint affectedKeyType = ballotsStorage.getBallotAffectedKeyType(ballotID);
        uint licensesIssuedFromGovernance = keysStorage.getLicensesIssuedFromGovernance();
        uint licensesLimitFromGovernance = keysManager.getLicensesLimitFromGovernance();
        if (affectedKeyType == 0) {//mining key
            if (licensesIssuedFromGovernance < licensesLimitFromGovernance) {
                keysStorage.increaseLicenses();
                validatorsStorage.addValidator(affectedKey);
            }
        } else if (affectedKeyType == 1) {//voting key
            keysStorage.setVotingKey(affectedKey, true);
            keysStorage.setVotingMiningKeysPair(affectedKey, miningKey);
            keysStorage.setMiningVotingKeysPair(miningKey, affectedKey);
        } else if (affectedKeyType == 2) {//payout key
            keysStorage.setPayoutKey(affectedKey, true);
            keysStorage.setMiningPayoutKeysPair(miningKey, affectedKey);
        }
    }

    function checkBallotsActivityPostActionRemove(uint ballotID) public {
        require(msg.sender == address(ballotsStorage));
        address affectedKey = ballotsStorage.getBallotAffectedKey(ballotID);
        address miningKey = ballotsStorage.getBallotMiningKey(ballotID);
        uint affectedKeyType = ballotsStorage.getBallotAffectedKeyType(ballotID);
        if (affectedKeyType == 0) {//mining key
            uint validatorLength = validatorsStorage.getValidatorsLength();
            for (uint jj = 0; jj < validatorLength; jj++) {
                if (validatorsStorage.getValidatorAtPosition(jj) == affectedKey) {
                    validatorsStorage.removeValidator(jj); 
                    return;
                }
            }
            validatorsStorage.disableValidator(affectedKey);
        } else if (affectedKeyType == 1) {//voting key
            keysStorage.setVotingKey(affectedKey, false);
            keysStorage.setVotingMiningKeysPair(0x0, miningKey);
            keysStorage.setMiningVotingKeysPair(miningKey, 0x0);
        } else if (affectedKeyType == 2) {//payout key
            keysStorage.setPayoutKey(affectedKey, false);
            keysStorage.setMiningPayoutKeysPair(miningKey, 0x0);
        }
    }
}