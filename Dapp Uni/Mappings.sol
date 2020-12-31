// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Mappings {

    /* Mapping = Key - Value storage |Hashtable in other languages*/
    mapping(uint => string) public names;
    mapping(uint => Book) public books;
    
    /* Nested Mapping */
    mapping(address => mapping(uint => Book)) public myBooks;

    struct Book {
        string title;
        string author;
    }
    
    constructor() {
        names[1] = "Alice";
        names[2] = "Bob";
        names[3] = "Carl";
    }
    
    function addBook(uint _id, string memory _title, string memory _author) public {
        books[_id] = Book(_title, _author);
    }
    
    function addMyBook(uint _id, string memory _title, string memory _author) public {
        myBooks[msg.sender][_id] = Book(_title, _author);
    }
}