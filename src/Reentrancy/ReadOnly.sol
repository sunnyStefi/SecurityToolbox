//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.18;
/**
 * Ex. Curve Pool.
 * Third pary systems built on top of outdated state can be expoited.
 *
 * Similar to CrossContract but reentering in third party systems that are using `isAllowedToWithdraw`.
 */

contract ReadOnly {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Withdrawal amount must be greater than 0");
        balances[msg.sender] = msg.value;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(isAllowedToWithdraw(msg.sender, amount), "Insufficient balance");

        (bool success,) = payable(msg.sender).call{value: amount}(""); //msg.sender has the EXECUTION CONTROL
        require(success, "Withdrawal failed");

        balances[msg.sender] -= amount;
    }

    function isAllowedToWithdraw(address user, uint256 amount) public view returns (bool) {
        return balances[user] >= amount;
    }
}


contract ThirdParty {
    ReadOnly readOnly;

    constructor(address _readOnly){
        readOnly = ReadOnly(_readOnly);
    }

    function isAllowedToWithdrawThirdParty(address user, uint256 amount) public view returns(bool){
        return readOnly.isAllowedToWithdraw(user, amount);

    }

}