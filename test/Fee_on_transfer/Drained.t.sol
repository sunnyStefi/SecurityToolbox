// //SPDX-License_Identifier: GPL:3.0

// import {CrossContractManager, CrossContractExecutor} from "../../src/Reentrancy/CrossContract.sol";
// import {Test, console} from "lib/forge-std/src/Test.sol";
// import {FeeOnTransferToken} from "../../src/utils/MyTokenERC20.sol";
// import "../../src/Fee_on_transfer/Drained.sol";

// pragma solidity ^0.8.18;

// contract DrainedTest is Test {
//     Vader vader;
//     FeeOnTransferToken feeOnTransferToken;
//     uint256 initialBalanceAttacker = 0;
//     uint256 initialBalanceVader = 0;
//     uint256 constant AMOUNT_ATTACKER = 999;
//     uint256 constant PERCENTAGE = 1;
//     address attacker = makeAddr("attacker");
//     uint256 enterAmount;

//     function setUp() external {
//         feeOnTransferToken = new FeeOnTransferToken(); //e.g. USDT
//         vader = new Vader(address(feeOnTransferToken));
//         // console.log(feeOnTransferToken.balanceOf(address(vader)));
//         vm.startPrank(address(vader));
//         feeOnTransferToken.approve(attacker, AMOUNT_ATTACKER);
//         enterAmount = AMOUNT_ATTACKER - (AMOUNT_ATTACKER * PERCENTAGE) / 100;
//         feeOnTransferToken.transfer(attacker, enterAmount);
//         initialBalanceAttacker = feeOnTransferToken.balanceOf(attacker);
//         initialBalanceVader = feeOnTransferToken.balanceOf(address(vader));
//         console.log(enterAmount);
//         vm.stopPrank();
//     }

//     function test_draining() external {
//         vm.startPrank(attacker);
//         feeOnTransferToken.approve(address(vader), AMOUNT_ATTACKER);  // I approve my tokens
//         uint256 newBaseValue = enterAmount - (enterAmount * PERCENTAGE) / 100;
//         vader.enter(newBaseValue);
//         assert(vader.balanceOf(attacker) == newBaseValue); //972
//         vader.leave();
//         assert(feeOnTransferToken.balanceOf(attacker) < newBaseValue); //963
//         //minting tokens are also out of balance..
//         vm.stopPrank();
//     }
// }
