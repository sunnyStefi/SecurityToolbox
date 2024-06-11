// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.18;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract MyTokenERC721 is ERC721 {
//     uint256 private _currentTokenId = 0;

//     constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

//     function mintTo(address recipient) public returns (uint256) {
//         uint256 newTokenId = _getNextTokenId();
//         _safeMint(recipient, newTokenId);
//         _incrementTokenId();
//         return newTokenId;
//     }

//     function _getNextTokenId() private view returns (uint256) {
//         return _currentTokenId + 1;
//     }

//     function _incrementTokenId() private {
//         _currentTokenId++;
//     }
// }
