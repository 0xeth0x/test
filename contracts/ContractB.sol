//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.9;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract ContractB is Ownable {
    address public contractA;

    // token => user => amount
    mapping(address => mapping(address => uint256)) public tokenToUserDeposit;

    event ContractASet(address newContractA);
    event DepositRecorded(address token, address user, uint256 amount);

    function setContractA(address _contractA)
        external
        onlyOwner
    {
        require(
            _contractA != address(0),
            "ContractA::setContractA: _contractA cannot be zero"
        );

        contractA = _contractA;
        emit ContractASet(_contractA);
    }

    function recordDeposit(
        address _user,
        address _token,
        uint256 _amount
    )
        external
        onlyOwnerOrContractA
    {
        require(
            _user != address(0)
            && _token != address(0),
            "ContractB::recordDeposit: invalid function parameters."

        );

        tokenToUserDeposit[_token][_user] += _amount;

        emit DepositRecorded(_token, _user, _amount);
    }

    function _onlyOwnerOrContractA() private view {
        require(
            msg.sender == owner()
            || msg.sender == contractA,
            "ContractB::onlyOwnerOrContractA: invalid caller."
        );
    }

    modifier onlyOwnerOrContractA {
        _onlyOwnerOrContractA();
        _;
    }
}