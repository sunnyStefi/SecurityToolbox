// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Registry} from "./Registry.sol";

contract RegistryTest is Test {
    Registry registry;
    address alice;

    function setUp() public {
        alice = makeAddr("alice");

        registry = new Registry();
    }

    function test_register() public {
        uint256 amountToPay = registry.PRICE();

        vm.deal(alice, amountToPay);
        vm.startPrank(alice);

        uint256 aliceBalanceBefore = address(alice).balance;

        registry.register{value: amountToPay}();

        uint256 aliceBalanceAfter = address(alice).balance;

        assertTrue(registry.isRegistered(alice), "Did not register user");
        assertEq(address(registry).balance, registry.PRICE(), "Unexpected registry balance");
        assertEq(aliceBalanceAfter, aliceBalanceBefore - registry.PRICE(), "Unexpected user balance");
    }

    function test_invariant2DoesNotHold(uint256 amount) public {
        //sending minimum price
        uint256 boundedAmount = bound(amount, registry.PRICE(), type(uint64).max);
        vm.startPrank(alice);
        vm.deal(alice, boundedAmount);
        uint256 balanceAliceBefore = address(alice).balance; //boundedAmount
        registry.register{value: boundedAmount}();
        vm.stopPrank();
        uint256 balanceAliceAfter = address(alice).balance;
        // this will fail: no change is gave back to the user that sends more than registry.PRICE()
        assertEq(balanceAliceBefore - registry.PRICE(), balanceAliceAfter); 
    }
}
