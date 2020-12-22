/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/// @title Storage contract for proxy setup.

contract Storage {

    /* Variable */
    uint256 number;

    /* Public functions */
    /// @dev Getter for number of dogs.
    /// @return number of dogs.
    function getNumber()
        internal view returns (uint)
    {
        return number;
    }

    /// @dev Setter for number of dogs.
    /// @param _number Number of dogs.
    function setNumber(uint256 _number)
        internal
    {
        number = _number;
    }
}