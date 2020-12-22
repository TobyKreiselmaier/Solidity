// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/// @title Migrations - Tracks last completed migration.

contract Migrations {

    /* Variables */
    address public owner;
    uint public last_completed_migration;

    /* Modifier */
    modifier restricted()
    {
        if (msg.sender == owner) {
          _;
        }
    }

    /* Constructor */
    constructor()
        public
    {
      owner = msg.sender;
    }

    /* Public Setter Function */
    /// @dev Tracks last completed migration.
    /// @param completed Array of initial owners.
    function setCompleted(uint completed)
        public restricted 
    {
        last_completed_migration = completed;
    }
}
