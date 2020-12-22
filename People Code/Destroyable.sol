/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Ownable.sol";

/// @title Destroyer - removes contract from blockchain.

contract Destroyable is Ownable{

    function close() public onlyOwner {
        selfdestruct(owner);
    }
}