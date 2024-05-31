// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//dummy ERC20 token
contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

//dummy fee on transfer ERC20token
contract FeeOnTransferToken is ERC20 {
    uint256 public transferFeePercentage = 1;

    constructor() ERC20("FeeOnTransferToken", "MFT") {}

    function _update(address sender, address recipient, uint256 amount) internal override(ERC20) {
        uint256 fee = (amount * transferFeePercentage) / 100;
        uint256 amountAfterFee = amount - fee;
        super._update(sender, address(this), fee); // Transfer the fee to the contract itself
        super._update(sender, recipient, amountAfterFee);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
