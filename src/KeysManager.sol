pragma solidity 0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./Owned.sol";

contract KeysManager is Owned {
	using SafeMath for uint256;

    // Max allowed number of initial keys
    int8 public initialKeysLimit = 12;
    // Max allowed number of all kind licenses (initial keys and governance)
    int8 public licensesLimit = 52;

    // Number of licenses allowed to issue by governance
    function getLicensesLimitFromGovernance() public view
        returns(uint licensesLimitFromGovernance)
    {
        return SafeMath.sub(uint(licensesLimit), uint(initialKeysLimit));
    }
}
