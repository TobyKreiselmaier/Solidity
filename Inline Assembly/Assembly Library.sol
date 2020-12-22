/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

library Sum {   
    /* Public functions */
    /// @dev Sums up the elements of an array of unsigned integers.
    /// @param _data Array of unsigned integers.
    /// @return Sum of array.
   function sumUsingInlineAssembly(uint[] memory _data)
      public pure returns (uint o_sum) 
   {
      for (uint i = 0; i < _data.length; ++i) {
         assembly {
            o_sum := add(o_sum, mload(add(add(_data, 0x20), mul(i, 0x20))))
         }
      }
   }
}

/// @title Simple Assembly Library Tester

contract Tester {

   /* Variable */
   uint[] data;
   
   /* Constructor */
   constructor() public {
      data.push(1);
      data.push(2);
      data.push(3);
      data.push(4);
      data.push(5);
   }

    /* Public function */
    /// @dev Sums an array of numbers using the external assembly library 'Sum'
    /// @return Sum of the array.
   function sum()
      external view returns(uint256)
   {
      return Sum.sumUsingInlineAssembly(data);
   }
}