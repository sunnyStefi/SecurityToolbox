//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MyToken} from "./utils/MyToken.sol";
/**
 * Attacker create swap
 * receive function attacker: execute
 * the swap will be canceled but then the mapping pendingswap says that's created
 */

contract CrossContractManager is ReentrancyGuard {
    struct Swap {
        address user;
        uint256 amount;
    }

    uint256 nonce;
    mapping(uint256 => Swap) public pendingSwaps;
    MyToken public token;

    constructor(address tokenAddress) {
        token = MyToken(tokenAddress);
        token.mint(address(this), 100);
    }

    function createSwap(uint256 _amount) external nonReentrant {
        token.transfer(msg.sender, _amount);
        pendingSwaps[++nonce] = Swap({user: msg.sender, amount: _amount});
    }

    function cancelSwap(uint256 _id) external nonReentrant {
        Swap memory swap = pendingSwaps[_id];
        require(swap.user == msg.sender);
        delete pendingSwaps[_id];

        token.transfer(msg.sender, swap.amount);
    }

    function getSwap(uint256 _id) external view returns (Swap memory) {
        return pendingSwaps[_id];
    }

    function getNonce() external returns (uint256) {
        return nonce;
    }
}

contract CrossContractExecutor is ReentrancyGuard {
    CrossContractManager manager;

    constructor(address _manager) {
        manager = CrossContractManager(_manager);
    }

    modifier onlyThisContract() {
        require(msg.sender != address(this), "Only this contract can perform the execution");
        _;
    }

    function executeSwap(uint256 _id) external onlyThisContract nonReentrant {
        CrossContractManager.Swap memory swap = manager.getSwap(_id);
        //execute swap
        manager.cancelSwap(_id);
    }
}
