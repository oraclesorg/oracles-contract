pragma solidity 0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./Owned.sol";

contract KeysManager is Owned {
	using SafeMath for uint256;

    int8 public initialKeysLimit = 25;
    int8 public licensesLimit = 52;

    function getLicensesLimitFromGovernance() public view returns(uint licensesLimitFromGovernance) {
        return SafeMath.sub(uint(licensesLimit), uint(initialKeysLimit));
    }
}
