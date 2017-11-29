pragma solidity 0.4.18;

import "./Owned.sol";
import "./ValidatorsStorage.sol";
import "./KeysStorage.sol";
import "./KeysManager.sol";


contract ValidatorsManager is Owned {
    ValidatorsStorage public validatorsStorage;
    KeysStorage public keysStorage;
    KeysManager public keysManager;

    function initialize(
        address validatorsStorageAddr,
        address keysStorageAddr,
        address keysManagerAddr
    ) public onlyOwner {
        require(address(validatorsStorage) == 0x0);
        require(address(keysStorage) == 0x0);
        require(address(keysManager) == 0x0);
        require(msg.sender == ValidatorsStorage(validatorsStorageAddr).owner());
        require(msg.sender == KeysStorage(keysStorageAddr).owner());
        require(msg.sender == KeysManager(keysManagerAddr).owner());

        setValidatorsStorage(validatorsStorageAddr);
        setKeysStorage(keysStorageAddr);
        setKeysManager(keysManagerAddr);
    }

    function setValidatorsStorage(address addr) public onlyOwner {
        require(address(validatorsStorage) == 0x0);
        require(msg.sender == ValidatorsStorage(addr).owner());
        validatorsStorage = ValidatorsStorage(addr);
    }

    function setKeysStorage(address addr) public onlyOwner {
        require(address(keysStorage) == 0x0);
        require(msg.sender == KeysStorage(addr).owner());
        keysStorage = KeysStorage(addr);
    }

    function setKeysManager(address addr) public onlyOwner {
        require(address(keysManager) == 0x0);
        require(msg.sender == KeysManager(addr).owner());
        keysManager = KeysManager(addr);
    }

    /**
    @notice Adds new notary from ceremony
    @param miningKey Notary's mining key
    @param zip Notary's zip code
    @param licenseID Notary's license ID
    @param licenseExpiredAt Notary's expiration date
    @param fullName Notary's full name
    @param streetName Notary's address
    @param state Notary's US state full name
    */
    function insertValidatorFromCeremony(
        address miningKey,
        uint zip,
        uint licenseExpiredAt,
        string licenseID,
        string fullName,
        string streetName,
        string state
    ) public {
        assert(keysStorage.checkInitialKey(msg.sender));
        assert(!validatorsStorage.isMiningKeyDataExists(miningKey));
        assert(keysStorage.initialKeysInvalidated() < keysManager.initialKeysLimit());

        validatorsStorage.setValidator(miningKey, fullName, streetName, state, zip, licenseID, licenseExpiredAt, 0, "");
    }

    /**
    @notice Adds new/updates existing notary from governance
    @param miningKey Notary's mining key
    @param zip Notary's zip code
    @param licenseID Notary's license ID
    @param licenseExpiredAt Notary's expiration date
    @param fullName Notary's full name
    @param streetName Notary's address
    @param state Notary's US state full name
    */
    function upsertValidatorFromGovernance(
        address miningKey,
        uint zip,
        uint licenseExpiredAt,
        string licenseID,
        string fullName,
        string streetName,
        string state
    ) public {
        assert(keysStorage.checkVotingKeyValidity(msg.sender));
        uint licensesIssuedFromGovernance = keysStorage.getLicensesIssuedFromGovernance();
        uint licensesLimitFromGovernance = keysManager.getLicensesLimitFromGovernance();
        if (keysStorage.votingMiningKeysPair(msg.sender) != miningKey) {
            assert(!validatorsStorage.isMiningKeyDataExists(miningKey));
            assert(licensesIssuedFromGovernance < licensesLimitFromGovernance);
        } else {
            assert(validatorsStorage.isMiningKeyDataExists(miningKey));
        }
        validatorsStorage.setValidator(miningKey, fullName, streetName, state, zip, licenseID, licenseExpiredAt, 0, "");
    }
}
