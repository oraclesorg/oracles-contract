pragma solidity 0.4.18;

import "./Utility.sol";
import "./Owned.sol";
import "./ValidatorsManager.sol";
import "./KeysStorage.sol";
import "./BallotsManager.sol";

contract ValidatorsStorage is Owned, Utility {
    address[] public validators;
    address[] public disabledValidators;
    
    struct Validator {
        string fullName;
        string streetName;
        string state;
        uint zip;
        string licenseID;
        uint licenseExpiredAt;
        uint disablingDate;
        string disablingTX;
    }
    
    mapping(address => Validator) public validator;

    /// Issue this log event to signal a desired change in validator set.
    /// This will not lead to a change in active validator set until 
    /// finalizeChange is called.
    ///
    /// Only the last log event of any block can take effect.
    /// If a signal is issued while another is being finalized it may never
    /// take effect.
    /// 
    /// _parent_hash here should be the parent block hash, or the
    /// signal will not be recognized.
    event InitiateChange(bytes32 indexed _parent_hash, address[] _new_set);

    ValidatorsManager public validatorsManager;
    KeysStorage public keysStorage;
    BallotsManager public ballotsManager;

    function ValidatorsStorage() public {
        validators.push(owner);
        InitiateChange(Utility.getLastBlockHash(), validators);
    }

    function initialize(address validatorsManagerAddr, address keysStorageAddr, address ballotsManagerAddr) public onlyOwner {
        require(msg.sender == KeysStorage(keysStorageAddr).owner());
        require(msg.sender == BallotsManager(ballotsManagerAddr).owner());
        require(msg.sender == ValidatorsManager(validatorsManagerAddr).owner());
        require(address(validatorsManager) == 0x0);
        require(address(keysStorage) == 0x0);
        require(address(ballotsManager) == 0x0);
        validatorsManager = ValidatorsManager(validatorsManagerAddr);
        keysStorage = KeysStorage(keysStorageAddr);
        ballotsManager = BallotsManager(ballotsManagerAddr);
    }

    function setValidatorsManager(address addr) public onlyOwner {
        require(address(validatorsManager) == 0x0);
        require(msg.sender == ValidatorsManager(addr).owner());
        validatorsManager = ValidatorsManager(addr);
    }

    function setkeysStorage(address addr) public onlyOwner {
        require(address(keysStorage) == 0x0);
        require(msg.sender == KeysStorage(addr).owner());
        keysStorage = KeysStorage(addr);
    }

    function setBallotsManager(address addr) public onlyOwner {
        require(address(ballotsManager) == 0x0);
        require(msg.sender == BallotsManager(addr).owner());
        ballotsManager = BallotsManager(addr);
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
        || msg.sender == address(keysStorage));
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
    ) public {
        require(msg.sender == address(validatorsManager));
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

    function isMiningKeyDataExists(address miningKey) public view returns (bool) {
        bytes memory name = bytes(validator[miningKey].fullName);
        return name.length > 0;
    }
}
