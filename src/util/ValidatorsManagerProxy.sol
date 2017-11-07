pragma solidity ^0.4.18;// solhint-disable-line compiler-fixed, compiler-gt-0_4

import "./../ValidatorsManager.sol";


contract ValidatorsManagerProxy is ValidatorsManager {
    function ValidatorsManagerProxy() public ValidatorsManager() {
        owner = 0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0;
    }

}
