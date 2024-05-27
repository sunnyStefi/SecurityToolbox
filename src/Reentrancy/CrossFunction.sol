//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";


/**
 * WARN: nonReentrant functions can be reentered by another function
*/
contract CrossFunction is ReentrancyGuard {

mapping(address => uint256) public balances;

function deposit() external payable {
    require(msg.value > 0, "Deposit must be greater than 0");
    balances[msg.sender] += msg.value;
}

function withdraw(uint256 amount) external nonReentrant {
    uint256 balance = balances[msg.sender];
    require (balance >= amount, "Insufficient balance");

    (bool success,) = payable(msg.sender).call{value: amount}("");
    require(success, "Withdrawal failed");

    balances[msg.sender] = balance - amount;
}

function transfer(address to, uint256 amount) external { //sending balances to an accomplice
    balances[msg.sender] -= amount;
    balances[to] += amount;
}
}