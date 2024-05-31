//SPDX-License_Identifier: GPL-3.0

import {CrossContractManager, CrossContractExecutor} from "../../src/Reentrancy/CrossContract.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {MyToken} from "../../src/utils/MyTokenERC20.sol";

pragma solidity ^0.8.18;

contract CrossContractTest is Test {
    CrossContractManager victimContract1;
    CrossContractExecutor victimContract2;
    MyToken myToken;
    Attacker attacker;
    address victim1 = makeAddr("victim1");
    uint256 amount = 1;
    uint256 nonce;

    function setUp() public {
        myToken = new MyToken();
        victimContract1 = new CrossContractManager(address(myToken));
        victimContract2 = new CrossContractExecutor(address(victimContract1));
        attacker = new Attacker(address(victimContract1), address(victimContract2));
        myToken.mint(address(attacker), 1);
        vm.deal(address(victimContract2), 1 ether);
    }

    function test_crossContract() public {
        vm.startPrank(address(attacker));
        myToken.approve(address(victimContract1), 1); //the attacker approves the manager to spend its tokens
        CrossContractManager(victimContract1).createSwap(amount);
        assert(myToken.balanceOf(address(CrossContractManager(victimContract1))) == 100);
        assert(myToken.balanceOf(address(attacker)) == 0);
        assert(address(attacker).balance == 0);

        nonce = CrossContractManager(victimContract1).getNonce(); //1
        CrossContractExecutor(victimContract2).executeSwap(nonce);
        assert(address(attacker).balance == 0.1 ether);
        assert(myToken.balanceOf(address(attacker)) == 0); // if
        vm.stopPrank();
    }
}

contract Attacker {
    address victimContract1;
    address victimContract2;
    uint256 nonce;

    constructor(address _victimContract1, address _victimContract2) {
        victimContract1 = _victimContract1;
        victimContract2 = _victimContract2;
    }

    receive() external payable {}
    // receive() external payable {
    //     //when transfer arrives here, the pendingSwap[1] has not been deleted yet
    //     //I can cancel the swap and get another transfer for free
    //     try CrossContractManager(victimContract1).cancelSwap(1) {} catch {}
    //     //best is to create a flag then call ano
    // }
}
