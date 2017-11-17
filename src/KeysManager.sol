pragma solidity 0.4.18;

import "./Owned.sol";

contract KeysManager is Owned {
    int8 public initialKeysLimit = 25;
    int8 public licensesLimit = 52;
}
