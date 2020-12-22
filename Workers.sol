/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./People.sol";

/// @title Child of People contract.

contract Workers is People{

    /* Variables */
    mapping(address => uint) internal salary;
    mapping(address => address) internal manager;

    /* Public functions */
    /// @dev Allows for creation of a new worker as a wrapper for createPerson()
    /// @param workerId Unique id for workers.
    /// @param name Name of worker.
    /// @param age Age of worker.
    /// @param height Height of worker.
    /// @param wages Wages of worker.
    function createWorker(address workerId, string memory name, uint age, uint height, uint wages)
        public
    {
        require(age <= 75, "Age can not exceed 75");
        require(workerId != msg.sender, "Worker can not be his/her own boss");
        createPerson(name, age, height);
        salary[workerId] = wages;
        manager[workerId] = msg.sender;
    }

    /// @dev Allows for the removal of a worker
    /// @param workerId Unique id for workers.
    function fire(address workerId)
        public
    {
        require(msg.sender == manager[workerId], "Caller needs to be the manager of this worker");
        deletePerson(workerId);
        delete salary[workerId];
        delete manager[workerId];
    }
}