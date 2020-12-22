/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Storage.sol";

/// @title Frontend for Proxy.sol

contract Dogs is Storage {

    /* Public functions */

    /* Getter function */
    /// @dev Getter for number of dogs.
    /// @return Returns number of dogs.
    function getNumberOfDogs()
        public view returns(uint256) 
    {
        return Storage.getNumber();
    }

    /* Setter function */
    /// @dev Setter for number of dogs.
    /// @param toSet number of dogs.
    function setNumberOfDogs (uint256 toSet)
        public 
    {
        Storage.setNumber(toSet);
    }
}