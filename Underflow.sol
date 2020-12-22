pragma solidity 0.5.12;

import "./Safemath.sol";

contract Underflow {
    
    using SafeMath for uint256;// SafeMath is a library. This is how to call a library. It's only built for uint256
    
    uint256 n = 0;
    
    function add() public returns (uint256){
        n = n.add(1);
        return n;
    }
    
    function subtract() public returns (uint256){
        n = n.sub(1);
        return n;
    }
}