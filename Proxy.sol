pragma solidity 0.5.1;

import "./Storage.sol";

contract ProxyDog is Storage {//wouldn't be called proxy in production

    address public currentAddress;

    constructor(address _currentAddress) public {//store address of functional contract
        currentAddress = _currentAddress;
    }

    function upgrade(address _currentAddress) public {//replace address of functional contract
        currentAddress = _currentAddress;
    }

    function getNumberOfDogs() public returns (bool, bytes memory){
        (bool success, bytes memory data) = currentAddress.delegatecall(abi.encodePacked(bytes4(keccak256("getNumberOfDogs()"))));
        return (success, data);
    }
    function setNumberOfDogs(uint256 _number) public returns (bool, bytes memory){
        (bool success, bytes memory data) = currentAddress.delegatecall(abi.encodePacked(bytes4(keccak256("setNumberOfDogs(uint256)")), _number));
        return (success, data);
    }
}