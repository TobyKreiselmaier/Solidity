// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Arrays {

    /* Advanced Data Types */
    uint[] public uintArray = [1,2,3]; //uint array
    string[] public stringArray = ["apple", "banana", "carrot"]; //string array
    string[] public values; //unassigned string array
    uint[][] public array2D = [ [1,2,3], [4,5,6] ]; // two dimensional uint array
    
    function addValue(string memory _value) public {
        values.push(_value);
    }

    function valueCount() public view returns(uint) {
        return values.length;
    }
}