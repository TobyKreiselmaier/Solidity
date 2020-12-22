/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Storage.sol";

/// @title Proxy Contract for Dog.sol

contract ProxyDog is Storage {//wouldn't be called proxy in production

    /* Variable */
    address public currentAddress;

    /* Constructor */
    ///@dev store address of functional contract
    constructor(address contractAddress) 
        public 
    {
        currentAddress = contractAddress;
    }

    /* Public functions */
    /// @dev Pointer to the new functional contract
    /// @param _owners Array of initial owners.
    function upgrade(address contractAddress)
        public 
    {
        currentAddress = contractAddress;
    }

    /// @dev Delegate Getter call.
    /// @return Success of call and call data.
    function getNumberOfDogs()
        public returns (bool, bytes memory)
    {
        (bool success, bytes memory data) = 
            currentAddress.delegatecall(abi.encodePacked(bytes4(keccak256("getNumberOfDogs()"))));
        return (success, data);
    }

    /// @dev Delegate Setter call.
    /// @param number Number of dogs.
    /// @return Success of call and call data.
    function setNumberOfDogs(uint256 number)
        public returns (bool, bytes memory)
    {
        (bool success, bytes memory data) = 
            currentAddress.delegatecall(abi.encodePacked(bytes4(keccak256("setNumberOfDogs(uint256)")), number));
        return (success, data);
    }
}