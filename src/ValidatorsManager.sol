pragma solidity 0.4.18;

import "oracles-contract-validator/ValidatorClass.sol";
import "./KeysManager.sol";


contract ValidatorsManager is ValidatorClass, KeysManager {
    
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
    function insertNewValidatorFromCeremony(
        address miningKey,
        uint zip,
        uint licenseExpiredAt,
        string licenseID,
        string fullName,
        string streetName,
        string state
    ) public {
        assert(checkInitialKey(msg.sender));
        assert(!isMiningKeyDataExists(miningKey));
        assert(licensesIssued < licensesLimit);

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
    function upsertNewValidatorFromGovernance(
        address miningKey,
        uint zip,
        uint licenseExpiredAt,
        string licenseID,
        string fullName,
        string streetName,
        string state
    ) public {
        assert(checkVotingKeyValidity(msg.sender));
        if (votingMiningKeysPair[msg.sender] != miningKey) {
            assert(!isMiningKeyDataExists(miningKey));
            assert(licensesIssued < licensesLimit);
        } else {
            assert(isMiningKeyDataExists(miningKey));
        }
        setValidator(miningKey, fullName, streetName, state, zip, licenseID, licenseExpiredAt, 0, "");
    }
    
    /**
    @notice Gets active notaries mining keys
    @return { "value" : "Array of active notaries mining keys" }
    */
    function getValidators() public constant returns (address[] value) {
        return validators;
    }
    
    /**
    @notice Gets disabled notaries mining keys
    @return { "value" : "Array of disabled notaries mining keys" }
    */
    function getDisabledValidators() public constant returns (address[] value) {
        return disabledValidators;
    }
    
    /**
    @notice Gets notary's full name
    @param addr Notary's mining key
    @return { "value" : "Notary's full name" }
    */
    function getValidatorFullName(address addr) public constant returns (string value) {
        return validator[addr].fullName;
    }
    
    /**
    @notice Gets notary's address
    @param addr Notary's mining key
    @return { "value" : "Notary's address" }
    */
    function getValidatorStreetName(address addr) public constant returns (string value) {
        return validator[addr].streetName;
    }
    
    /**
    @notice Gets notary's state full name
    @param addr Notary's mining key
    @return { "value" : "Notary's state full name" }
    */
    function getValidatorState(address addr) public constant returns (string value) {
        return validator[addr].state;
    }
    
    /**
    @notice Gets notary's zip code
    @param addr Notary's mining key
    @return { "value" : "Notary's zip code" }
    */
    function getValidatorZip(address addr) public constant returns (uint value) {
        return validator[addr].zip;
    }
    
    /**
    @notice Gets notary's license ID
    @param addr Notary's mining key
    @return { "value" : "Notary's license ID" }
    */
    function getValidatorLicenseID(address addr) public constant returns (string value) {
        return validator[addr].licenseID;
    }
    
    /**
    @notice Gets notary's license expiration date
    @param addr Notary's mining key
    @return { "value" : "Notary's license expiration date" }
    */
    function getValidatorLicenseExpiredAt(address addr) public constant returns (uint value) {
        return validator[addr].licenseExpiredAt;
    }

    /**
    @notice Gets notary's disabling date
    @param addr Notary's mining key
    @return { "value" : "Notary's disabling date" }
    */
    function getValidatorDisablingDate(address addr) public constant returns (uint value) {
        return validator[addr].disablingDate;
    }

    function setValidator(address miningKey, string fullName, string streetName, string state, uint zip, string licenseID, uint licenseExpiredAt, uint disablingDate, string disablingTX) internal {
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
