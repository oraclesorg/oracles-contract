pragma solidity 0.4.18;

import "./Owned.sol";
import "./Utility.sol";
import "oracles-contract-validator/ValidatorClass.sol";
import "./KeysManager.sol";
import "./BallotsManager.sol";


contract ValidatorsManager is ValidatorClass, Owned, Utility {

    BallotsManager public ballotsManager;
    KeysManager public keysManager;

    function ValidatorsManager() public {
        validators.push(owner);
        InitiateChange(Utility.getLastBlockHash(), validators);
    }

    function setBallotsManager(address addr) public onlyOwner {
        require(msg.sender == BallotsManager(addr).owner());
        ballotsManager = BallotsManager(addr);
    }

    function setKeysManager(address addr) public onlyOwner {
        require(msg.sender == KeysManager(addr).owner());
        keysManager = KeysManager(addr);
    }

    /**
    @notice Adds new notary
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
        assert(keysManager.checkInitialKey(msg.sender));
        assert(!isMiningKeyDataExists(miningKey));
        assert(keysManager.initialKeysInvalidated() < keysManager.licensesLimit());

        setValidator(miningKey, fullName, streetName, state, zip, licenseID, licenseExpiredAt, 0, "");
    }

    /**
    @notice Adds new notary
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
        assert(keysManager.checkVotingKeyValidity(msg.sender));
        if (keysManager.votingMiningKeysPair(msg.sender) != miningKey) {
            assert(!isMiningKeyDataExists(miningKey));
            assert(keysManager.licensesIssued() < keysManager.licensesLimit());
        } else {
            assert(isMiningKeyDataExists(miningKey));
        }
        setValidator(miningKey, fullName, streetName, state, zip, licenseID, licenseExpiredAt, 0, "");
    }
    
    /**
    @notice Gets active notaries mining keys
    @return { "value" : "Array of active notaries mining keys" }
    */
    function getValidators() public view returns (address[] value) {
        return validators;
    }

    function getValidatorsLength() public view returns (uint value) {
        return validators.length;
    }

    function getValidatorAtPosition(uint i) public view returns (address value) {
        return validators[i];
    }
    
    /**
    @notice Gets disabled notaries mining keys
    @return { "value" : "Array of disabled notaries mining keys" }
    */
    function getDisabledValidators() public view returns (address[] value) {
        return disabledValidators;
    }

    function getDisabledValidatorsLength() public view returns (uint value) {
        return disabledValidators.length;
    }

    function getDisabledValidatorAtPosition(uint i) public view returns (address value) {
        return disabledValidators[i];
    }
    
    /**
    @notice Gets notary's full name
    @param addr Notary's mining key
    @return { "value" : "Notary's full name" }
    */
    function getValidatorFullName(address addr) public view returns (string value) {
        return validator[addr].fullName;
    }
    
    /**
    @notice Gets notary's address
    @param addr Notary's mining key
    @return { "value" : "Notary's address" }
    */
    function getValidatorStreetName(address addr) public view returns (string value) {
        return validator[addr].streetName;
    }
    
    /**
    @notice Gets notary's state full name
    @param addr Notary's mining key
    @return { "value" : "Notary's state full name" }
    */
    function getValidatorState(address addr) public view returns (string value) {
        return validator[addr].state;
    }
    
    /**
    @notice Gets notary's zip code
    @param addr Notary's mining key
    @return { "value" : "Notary's zip code" }
    */
    function getValidatorZip(address addr) public view returns (uint value) {
        return validator[addr].zip;
    }
    
    /**
    @notice Gets notary's license ID
    @param addr Notary's mining key
    @return { "value" : "Notary's license ID" }
    */
    function getValidatorLicenseID(address addr) public view returns (string value) {
        return validator[addr].licenseID;
    }
    
    /**
    @notice Gets notary's license expiration date
    @param addr Notary's mining key
    @return { "value" : "Notary's license expiration date" }
    */
    function getValidatorLicenseExpiredAt(address addr) public view returns (uint value) {
        return validator[addr].licenseExpiredAt;
    }

    /**
    @notice Gets notary's disabling date
    @param addr Notary's mining key
    @return { "value" : "Notary's disabling date" }
    */
    function getValidatorDisablingDate(address addr) public view returns (uint value) {
        return validator[addr].disablingDate;
    }

    function addValidator(address addr) public {
        require(msg.sender == address(ballotsManager) 
        || msg.sender == address(keysManager));
        validators.push(addr);
        InitiateChange(Utility.getLastBlockHash(), validators);
    }

    function disableValidator(address addr) public {
        require(msg.sender == address(ballotsManager));
        disabledValidators.push(addr);
        validator[addr].disablingDate = now;
    }

    /**
    @notice Removes element by index from validators array and shift elements in array
    @param index Element's index to remove
    @return { "value" : "Updated validators array with removed element at index" }
    */
    function removeValidator(uint index) public returns(address[]) {
        require(msg.sender == address(ballotsManager));
        if (index >= validators.length) return;

        for (uint i = index; i < validators.length-1; i++) {
            validators[i] = validators[i+1];
        }
        delete validators[validators.length-1];
        validators.length--;
    }

    function setValidator(
        address miningKey,
        string fullName,
        string streetName,
        string state,
        uint zip,
        string licenseID,
        uint licenseExpiredAt,
        uint disablingDate,
        string disablingTX
    ) internal {
        validator[miningKey] = Validator({
            fullName: fullName, 
            streetName: streetName, 
            state: state, 
            zip: zip, 
            licenseID: licenseID, 
            licenseExpiredAt: licenseExpiredAt, 
            disablingDate: disablingDate, 
            disablingTX: disablingTX
        });
    }

    function isMiningKeyDataExists(address miningKey) internal view returns (bool) {
        bytes memory name = bytes(validator[miningKey].fullName);
        return name.length > 0;
    }
}
