/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/// @title Fundraiser simulates DAO. Will be attacked by attacker.sol

contract Fundraiser{

    /* Variables */
    mapping  (address => uint) balances;

    /* Public functions */
    /// @dev Collecting funds.
    function contribute()
        public payable
    {
        balances[msg.sender] += msg.value;
    }

    /// @dev Withdraw funds.
    function withdraw()
        public
    {
        if(balances[msg.sender] == 0){
            revert;
        }
        balances[msg.sender] = 0;
        msg.sender.call.value(balances[msg.sender]);
    }

    /// @dev Get contract balance.
    /// @return Returns contract balance.
    function getFunds()
        public returns (uint)
    {
        return address(this).balance;
    }
}