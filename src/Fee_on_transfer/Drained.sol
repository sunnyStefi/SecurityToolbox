// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.18;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
// import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
// import {FeeOnTransferToken} from "../utils/MyTokenERC20.sol";
// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// contract Vader is ERC20, ERC20Permit, ERC20Votes {
//     FeeOnTransferToken public tokenWithFees;
//     uint256 totalShares = 0;

//     constructor(address _token) ERC20("Vader", "VT") ERC20Permit("Vader") {
//         tokenWithFees = FeeOnTransferToken(_token);
//         tokenWithFees.mint(address(this), 1000);
//     }

//     function enter(uint256 _amount) external {
//         _mint(msg.sender, _amount);
//         tokenWithFees.transferFrom(msg.sender, address(this), _amount);
//     }

//     function leave() external {
//         uint256 usersActualAmount = tokenWithFees.balanceOf(address(this));
//         _burn(msg.sender, usersActualAmount);
//         tokenWithFees.approve(address(this), 1000); //I approve my tokens
//         tokenWithFees.transferFrom(address(this), msg.sender, usersActualAmount);
//     }

//     function nonces(address owner) public view virtual override(ERC20Permit, Nonces) returns (uint256) {
//         return super.nonces(owner);
//     }

//     function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Votes) {
//         super._update(from, to, value);
//     }
// }
