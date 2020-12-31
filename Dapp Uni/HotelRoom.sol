// SPDX-License-Identifier: UNLICENSED
// Paying in ether
// Modifiers
// Visibility
// Events
// Enums

pragma solidity ^0.6.0;

contract HotelRoom {

    enum Status {Vacant, Occupied}
    Status currentStatus;
    
    event Occupy(address _occupant, uint _value);
    
    address payable public owner;

    constructor() public {
        owner = msg.sender;
        currentStatus = Status.Vacant;
    }

    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Insufficient funds.");
        _;
    }
    modifier onlyWhileVacant {
        require(currentStatus == Status.Vacant, "Currently occupied.");
        _;
    }

    receive() external payable costs(2 ether) onlyWhileVacant {
        currentStatus = Status.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender, msg.value);
    }
}