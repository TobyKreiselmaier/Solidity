/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Destroyable.sol";

/// @title People contract - showing basic solidity functionality.

contract People is Destroyable{

    /* Events */
    event personCreated(string name, uint age, uint height, bool senior, address createdBy);
    event personUpdated(string nameOld, uint ageOld, uint heightOld, bool seniorOld, string nameNew, uint ageNew, uint heightNew, bool seniorNew, address updatedBy);
    event personDeleted(string name, uint age, uint height, bool senior, address deletedBy);

    /* Variables */
    uint public balance;
    mapping(address => Person) internal people;
    address[] private creators;
    struct Person 
    {
        string name;
        uint age;
        uint height;
        bool senior;
    }

    /* Modifiers */
    modifier costs(uint cost)
    {
        require(msg.value >= cost);
        _;
    }

    /* Public functions */
    /// @dev Creating a person struct.
    /// @param name Name of person.
    /// @param age Age of person.
    /// @param height Height of person.
    function createPerson(string memory name, uint age, uint height)
        public
    {
        balance += msg.value;
        string memory nameOld = people[msg.sender].name;
        uint ageOld = people[msg.sender].age;
        uint heightOld = people[msg.sender].height;
        bool seniorOld = people[msg.sender].senior;
        require(age < 130, "Age needs to be below 130");
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        if(age >= 65){
            newPerson.senior = true;
        } else {
            newPerson.senior = false;
        }
        insertPerson(newPerson);
        creators.push(msg.sender);
        assert(
            keccak256(abi.encodePacked(people[msg.sender].name, people[msg.sender].age, people[msg.sender].height, people[msg.sender].senior)) 
            == 
            keccak256(abi.encodePacked(newPerson.name, newPerson.age, newPerson.height, newPerson.senior))
            ); 
        if (ageOld == 0) {
            emit personCreated(newPerson.name, newPerson.age, newPerson.height, newPerson.senior, msg.sender);
        } else {
            emit personUpdated(nameOld, ageOld, heightOld, seniorOld, newPerson.name, newPerson.age, newPerson.height, newPerson.senior, msg.sender);
        }
    }

    /// @dev Inserting a person struct into a mapping.
    /// @param newPerson New Person as a struct.
    function insertPerson(Person memory newPerson)
        public 
    {
        address creator = msg.sender;
        people[creator] = newPerson;
    }

    /// @dev Getter for a person.
    /// @return Returns the values of msg.sender.
    function getPerson()
        public view returns(string memory name, uint age, uint height, bool senior) 
    {
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);    
    }
    
    /// @dev Delete a person.
    /// @param creator Address of which the data is to be deleted.
    function deletePerson(address creator)
        public 
    {
        string memory name = people[creator].name;
        uint age = people[creator].age;
        uint height = people[creator].height;
        bool senior = people[creator].senior;
        delete people[creator];
        assert(people[creator].age == 0);
        emit personDeleted(name, age, height, senior, msg.sender);
    }

    /// @dev Determines the creator of a person.
    /// @param index Index within creators mapping.
    /// @return Address of creator.
    function getCreator(uint index)
        public view onlyOwner returns(address)
    {
        return creators[index];
    }

    /// @dev Allows owner to withdraw all contract funds.
    /// @return Contract balance.
    function withdrawAll()
        public onlyOwner returns(uint)
    {
        uint toTransfer = balance;
        balance = 0;
        if(msg.sender.send(toTransfer)){
        } else {
            balance = toTransfer;
            return 0;
        }
        return toTransfer;
    }
}