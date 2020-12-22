/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Library.sol";

/// @title Simulates a contract that depends on a vulnerable library.

contract Fundraiser{
    
    /// @dev Need to set address of library once deployed.
    //Library lib = Library(0xbbf289d846208c16edc8474705c748aff07732db);
    
    /* Variable */
    mapping  (address => uint) balances;
    
    /* Public functions */
    /// @dev Allows users to send funds.
    function contribute()
        public payable
    {
        balances[msg.sender] += msg.value;
    }
    
    /// @dev Allows users to withdraw funds.
    /// @dev Contract will freeze in line 31.
    function withdraw()
        public
    {
        require(balances[msg.sender] > 0);
        if(lib.isNotPositive(balances[msg.sender])){
            revert;
        }
        msg.sender.call.value(balances[msg.sender]);
        balances[msg.sender] = 0;
    }
    
    /// @dev Getter for contract balance.
    /// @return Contract balance.
    function getFunds()
        public returns (uint)
    {
        return address(this).balance;
    }
}