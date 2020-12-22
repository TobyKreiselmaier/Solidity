/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/// @title Library simulating Parity freeze attack.

contract Library{

    /* Variables */
    address owner;

    /* Modifiers */
    modifier onlyOwner 
    {
        if(msg.sender != owner){
            revert;
        }
        _;
    }

    /* Public functions */
    /// @dev Simple function that returns true/false.
    /// @param number Number to be processed.
    /// @return true - if number is negative | false - if number is positive.
    function isNotPositive(uint number)
        public returns (bool)
    {
        if(number<=0){
            return true;
        }
        return false;
    }

    /// @dev Selfdestruct function
    function destroy() 
        public onlyOwner 
    {
        selfdestruct(owner);
    }
    
    /// @dev Allows reassigning of owner. Here is where the contract is vulnerable.
    function initOwner()
        public 
    {
        if(owner==address(0)){
            owner = msg.sender;
        }
        else{
            revert;
        }
    }
}