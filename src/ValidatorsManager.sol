pragma solidity ^0.4.14;

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
    function addValidator(
        address miningKey,
        uint zip,
        uint licenseExpiredAt,
        string licenseID,
        string fullName,
        string streetName,
        string state
    ) public {
        assert(checkVotingKeyValidity(msg.sender) || checkInitialKey(msg.sender));
        if (checkVotingKeyValidity(msg.sender)) {
            if (votingMiningKeysPair[msg.sender] != miningKey) {
                bytes memory newValidatorFullName = bytes(validator[miningKey].fullName);
                assert(newValidatorFullName.length == 0);
                assert(licensesIssued < licensesLimit);
            } else {
                bytes memory curValidatorFullName = bytes(validator[miningKey].fullName);
                assert(curValidatorFullName.length > 0);
            }
        }
        if (checkInitialKey(msg.sender)) {
            bytes memory validatorFullName = bytes(validator[miningKey].fullName);
            assert(validatorFullName.length == 0);
            assert(licensesIssued < licensesLimit);
        }
        validator[miningKey] = Validator({
            fullName: fullName, 
            streetName: streetName, 
            state: state, 
            zip: zip, 
            licenseID: licenseID, 
            licenseExpiredAt: licenseExpiredAt, 
            disablingDate: 0, 
            disablingTX: ""
        });
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
}
