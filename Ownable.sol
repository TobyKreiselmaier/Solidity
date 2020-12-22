// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/// @title Ownable allows to restrict functionality to deployer of contract.

contract Ownable{

    /* Variable */
    address payable internal _owner;

    /* Modifier */
    modifier onlyOwner()
    {
        require(msg.sender == _owner, 
        "You need to be owner of the contract in order to access this functionality!");
        _;
    }

    /* Constructor */
    constructor()
        public 
    { 
        _owner = msg.sender;
    }
}