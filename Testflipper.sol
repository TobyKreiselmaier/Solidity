// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

import "./CoinFlipper.sol";

contract TestFlipper is CoinFlipper {

    function testPayout(uint256 amount, address payable to) public {
        _payout(amount, to);
    }

    function testSetWaitingMapping(address user, bool status) public {
            waitingPlayers[user] = status;
    }

    function testGetWaitingMapping(address user) public view returns (bool) {
        return waitingPlayers[user];
    }

    function testGetBetsMapping(bytes32 queryId) 
            public view returns (address player, uint256 stake, uint256 choice) {
        return (pendingBets[queryId].player, pendingBets[queryId].stake, pendingBets[queryId].choice);
    }

    function testSetUserBalance(uint256 amount) public {//doesn't change contract balance
        userBalances[msg.sender] = amount;//only for testing
    }
}