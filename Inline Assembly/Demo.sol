/// SPDX-License-Identifier: UNLICENSED

/// @dev full list of opcodes here: https://docs.soliditylang.org/en/v0.8.0/yul.html#evm-dialect
/// @dev Assembly allows for fine grained management of memory
/// @dev Assembly can help save gas costs

pragma solidity ^0.8.0; 

/// @title Simple contract to demonstrate Inline Assembly

contract InlineAssembly { 

    /// @dev Function that simulates adding 28 in two steps to a number
    /// @param a Input number.
    /// @return Output number.
	function addition(uint256 a)
        public view returns (uint256 b)
    { 
		assembly { 
			// Create variable 'c' and assign the sum of a and 16 
			let c := add(a, 16) 

			// Use 'mstore' opcode to store 'c' in memory at address 0x80 
			mstore(0x80, c) 
			{ 

			// Creating a new variable 'd' and assign the sum of c and 12
				let d := add(sload(c), 12) 

			// assign the value of 'd' to 'b' 
				b := d 

			// 'd' is deallocated now 
			} 
	
			// Calculate the sum of 'b+c' assign the value to 'b' 
			b := add(b, c) 

		// 'c' is deallocated here 
		}
	}
}