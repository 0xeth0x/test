//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.9;

import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {ContractB} from "./ContractB.sol";

contract ContractA is Ownable {
    using SafeERC20 for IERC20;

    ContractB public contractB;

    event ContractBSet(address newContractB);

    function setContractB(address _contractB)
        external
        onlyOwner
    {
        require(
            _contractB != address(0),
            "ContractB::setContractB: _contractB cannot be zero"
        );

        contractB = ContractB(_contractB);
        emit ContractBSet(_contractB);
    }

    function deposit(
        IERC20 _token,
        uint256 _amount
    ) external {
        require(
            _token != IERC20(address(0))
            && _amount != 0,
            "ContractA::deposit: Invalid function parameters."
        );

        _token.safeTransferFrom(
            msg.sender,
            address(this),
            _amount
        );

        contractB.recordDeposit(
            msg.sender,
            address(_token),
            _amount
        );
    }
}
