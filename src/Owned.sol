pragma solidity ^0.4.18;// solhint-disable-line compiler-fixed, compiler-gt-0_4


contract Owned {
    address public owner;

    function Owned() public {
        owner = 0xDd0BB0e2a1594240fED0c2f2c17C1E9AB4F87126; //msg.sender
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}
