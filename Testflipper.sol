// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./CoinFlipper.sol";

/// @title Testfunctions for CoinFlipper.sol

contract TestFlipper is CoinFlipper {

    /* Test functions */
    /// @dev Access _payout().
    /// @param _amount Amount that is paid.
    /// @param _to Recipient's address.
    function testPayout(uint256 amount, address payable to) public {
        _payout(amount, to);
    }

    /// @dev Access waitingPlayers[].
    /// @param user Player to be checked if waiting on oracle.
    function testGetWaitingMapping(address user)
        public view returns (bool)
    {
        return waitingPlayers[user];
    }

    /// @dev Access pendingBets[].
    /// @param requestId Request Id from Chainlink.
    /// @return Address of player, his stake, and initial choice with this request Id.
    function testGetBetsMapping(bytes32 requestId)
            public view returns (address player, uint256 stake, uint256 choice)
    {
        return (pendingBets[requestId].player, pendingBets[requestId].stake, pendingBets[requestId].choice);
    }

    /// @dev Set waitingPlayers[].
    /// @param user Player that is to be set in the mapping.
    /// @param status True = player is waiting | False = player is not waiting.
    function testSetWaitingMapping(address user, bool status)
        public 
    {
        waitingPlayers[user] = status;
    }

    /// @dev Set userBalances[].
    /// @param amount Testamount to be set.
    function testSetUserBalance(uint256 amount)
        public 
    {
        userBalances[msg.sender] = amount;
    }
}