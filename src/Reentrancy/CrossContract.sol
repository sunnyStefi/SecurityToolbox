// //SPDX-License-Identifier: GPL-3.0

// pragma solidity ^0.8.18;

// import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import {MyToken} from ".././utils/MyTokenERC20.sol";
// /**
//  * Contract that swaps 1 ERC20 token for 0.1 ETH.
//  * //q  Which state is not up to date when the external call is executed?
//  *
//  * ReentrancyGuard can check reentrancy only inside the same contract!
//  *
//  * Reentrancy attack:
//  * Attacker create swap
//  * receive function attacker: execute
//  * the swap will be canceled but then the mapping pendingswap says that's created
//  */

// contract CrossContractManager is ReentrancyGuard {
//     struct Swap {
//         address user;
//         uint256 amount;
//     }

//     uint256 nonce;
//     mapping(uint256 => Swap) public pendingSwaps;
//     MyToken public token;

//     event user(address indexed user);

//     constructor(address tokenAddress) {
//         token = MyToken(tokenAddress);
//         token.mint(address(this), 99);
//     }

//     //request to have a token swap executed
//     function createSwap(uint256 _amount) external nonReentrant {
//         token.transferFrom(msg.sender, address(this), _amount); //the user is sending token to this contract
//         pendingSwaps[++nonce] = Swap({user: msg.sender, amount: _amount});
//     }

//     //request can be cancelled and they have the amount of token back
//     function cancelSwap(uint256 _id) external nonReentrant {
//         Swap memory swap = pendingSwaps[_id];
//         // require(swap.user == msg.sender);
//         delete pendingSwaps[_id];
//         token.transfer(msg.sender, swap.amount);
//     }

//     function getSwap(uint256 _id) external view returns (Swap memory) {
//         return pendingSwaps[_id];
//     }

//     function getNonce() external returns (uint256) {
//         return nonce;
//     }
// }

// contract CrossContractExecutor is ReentrancyGuard {
//     CrossContractManager manager;
//     uint256 constant BASE_FEE = 0.1 ether;

//     constructor(address _manager) {
//         manager = CrossContractManager(_manager);
//     }

//     modifier onlyThisContract() {
//         require(msg.sender != address(this), "Only this contract can perform the execution");
//         _;
//     }

//     function executeSwap(uint256 _id) external onlyThisContract nonReentrant {
//         CrossContractManager.Swap memory swap = CrossContractManager(manager).getSwap(_id);
//         payable(swap.user).transfer(BASE_FEE * swap.amount); //swap execution - attack
//         manager.cancelSwap(_id);
//     }
// }
