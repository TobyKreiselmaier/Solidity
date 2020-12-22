pragma solidity ^0.5.12;

import "./VRFConsumerBase.sol";

contract Randomizer is VRFConsumerBase {

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    
    constructor()
        VRFConsumerBase(
            0xf720CF1B963e0e7bE9F58fd471EFa67e7bF00cfb, // VRF Coordinator
            0x20fE562d797A42Dcb3399062AE9546cd06f63280  // LINK Token
        ) public
    {
        keyHash = 0xced103054e349b8dfb51352f0f8fa9b5d20dde3d06f9f43cb2b85bc64b238205;
        fee = 10 ** 17; // 0.1 LINK
    }

    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) { //user provides number to random function, it's non-predictable
        require(LINK.balanceOf(address(this)) > fee);
        return requestId = requestRandomness(keyHash, fee, userProvidedSeed);
    }
    
    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) external { //function will be called by Chainlink oracle
        randomResult = randomNumber;
    }
}