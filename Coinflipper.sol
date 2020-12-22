// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

import "./Ownable.sol";
import "./SafeMath.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract CoinFlipper is Ownable, VRFConsumerBase {

    using SafeMath for uint256;

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    uint256 public jackpot;

    constructor()
        VRFConsumerBase(
            0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9, // VRF Coordinator
            0xa36085F69e2889c224210F603D836748e7dC0088  // LINK Token
        ) public
    {
        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }

    event newQuery(address caller, bytes32 requestId, string desription);
    //generated by flipCoin()
    event generatedRandomNumber(uint256 randomNumber);
    //generated by handleResult()
    event flipResult(address player, bytes32 requestId, uint256 amount, bool won, uint256 result);
    //generated by handleResult()
    event withdrawal(uint256 amount);
    //generated by _payout()
    event deposit(uint256 amount);
    //generated by fundContract()

    struct bet {
        address player;
        uint256 stake;
        uint256 choice;// 0 - Heads | 1 - Tails
    }

    mapping(address => bool) public waitingPlayers;
    //records which players are currently playing.
    mapping(bytes32 => bet) public pendingBets;
    //players that wait for callback of oracle
    mapping(address => uint256) public userBalances;
    //balances of users they can collect.

    modifier costs(uint256 cost){
        require(msg.value >= cost, "insufficient funds");
        _;
    }

    function _payout(uint256 _amount, address payable _to) internal {
        require(jackpot >= _amount, "Insufficient funds in jackpot");
        _to.transfer(_amount);
        emit withdrawal(_amount);
    }

    function getContractBalance() public view returns (uint256) {
        return jackpot;
    }

    function getUserBalance() public view returns (uint256) {
        return userBalances[msg.sender];
    }

    function getContractOwner() external view returns (address) {
        return _owner;
    }

    //For testing in Ganache:
    //function testRandom() public view returns (bytes32) {
    //    bytes32 requestId = bytes32(keccak256(abi.encodePacked(msg.sender)));
    //    __callback(requestId, "1", bytes("test"));
    //    return requestId;
    //}

    function flipCoin(uint256 choice) public payable costs(0.01 ether) returns (bytes32){
        //make sure a player that already has a requestId can not play.
        require(waitingPlayers[msg.sender] == false, 
        "Player is already waiting for another oracle");
        require(msg.value >= 0.01 ether, "Stake too low");
        require(msg.value <= jackpot / 10, "Stake too high");
        //bet is caped at 10% of jackpot to ensure there are always enough funds
        //as many players maybe waiting and funds will be different from when
        //they are checked here to when they are actually transferred to the userBalances mapping.
        
        //For testing in Ganache:
        //bytes32 requestId = testRandom();
        //

        //use on Testnet:
        bytes32 requestId = getRandomNumber(block.timestamp);
        //requestId will be returned immediately
        //

        pendingBets[requestId] = bet(msg.sender, msg.value, choice);
        //save bet in mapping
        waitingPlayers[msg.sender] = true;
        //a player can have one pending bet
        jackpot = SafeMath.add(jackpot, msg.value);
        //store user funds in jackpot

        emit newQuery(msg.sender, requestId, 
            'Query sent to oracle, waiting for answer...');

        //For testing in Ganache:
        //uint256 randomNumber = now % 2;// returns either 0 or 1
        //handleResult(requestId, randomNumber);
        //
        return requestId;
    }

     /** 
     * Requests randomness from a user-provided seed
     */
    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }

     /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
        handleResult(requestId, randomResult);
    }

    function handleResult(bytes32 requestId, uint256 randomNumber) public {
        emit generatedRandomNumber(randomNumber);
        bet memory returnedUser = pendingBets[requestId];
        //return info about this bet from mapping
        if(returnedUser.choice == randomNumber) {
            //compare user's choice with oracle result
            uint256 win = returnedUser.stake * 2;//double the stakes
            jackpot = SafeMath.sub(jackpot, win);//remove funds from jackpot
            userBalances[returnedUser.player] = 
                SafeMath.add(userBalances[returnedUser.player], win);
            //save funds in user mapping so they can collect them
            emit flipResult(returnedUser.player, requestId, win, true, randomNumber);
        } else {
            emit flipResult(returnedUser.player, requestId, 0, false, randomNumber);
        }
        waitingPlayers[returnedUser.player] = false;
        //clear mapping so user can play again
    }

    function userWithdrawFunds() public payable {
        require(userBalances[msg.sender] > 0, "No funds to withdraw");//checks
        uint256 toWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;//effects
        _payout(toWithdraw, msg.sender);//interactions
        assert(userBalances[msg.sender] == 0);
    }

    //functions for owner
    function fundContract() public payable onlyOwner {
        require(msg.value > 0);
        jackpot = SafeMath.add(jackpot, msg.value);
        emit deposit(msg.value);
    }

    function ownerWithdrawAll() public payable onlyOwner {
        require(jackpot >= 0, "No funds available to withdraw");
        _payout(jackpot, msg.sender);
        jackpot = 0;
    }
}