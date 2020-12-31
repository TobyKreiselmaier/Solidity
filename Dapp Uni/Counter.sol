// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Counter {
    
    /* Variables */
    uint public count = 0;


    /* Public Functions */
    function incrementCount() public {
        count ++;
    }
}