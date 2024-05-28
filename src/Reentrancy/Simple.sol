//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.18;
/**
 * Issue: exploit a piece of outdated state when we hand out the execution to an external address
 * call will execute the receive/fallback function of msg.sender, which can be a contract
 * msg.sender will gain control of execution in his receive function
 */
contract Simple {
    error Vault_NativeTokenTransfer();

    mapping(address => uint256) balances;

    function deposit() external payable {
        balances[msg.sender] = msg.value;
    }

    function withdraw() external {
        (bool sent,) = payable(msg.sender).call{value: balances[msg.sender]}(""); //msg.sender has the EXECUTION CONTROL
        if (!sent) revert Vault_NativeTokenTransfer();
        delete balances[msg.sender]; //OUTDATED
    }
}
