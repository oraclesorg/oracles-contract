pragma solidity ^0.4.11;

import "ds-test/test.sol";
import "./owned.sol";

contract HelperContract is owned {
    function check() onlyOwner {
    }
}

contract OwnedTest is DSTest {
    owned ownedDeployed;
    HelperContract h;
    function setUp(){
        ownedDeployed = new owned();
    }

    function testDefaultOwner() {
        assertEq(address(ownedDeployed.owner()), address(0xDd0BB0e2a1594240fED0c2f2c17C1E9AB4F87126));
    }

    function testFailModifierOnlyOwner(){
        h = new HelperContract();
        h.check();
    }

}
