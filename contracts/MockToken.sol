//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.9;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
	constructor() ERC20("MOCK Token", "MKTN") {
		_mint(msg.sender, 100_000_000 * 10 ** decimals());
	}
}