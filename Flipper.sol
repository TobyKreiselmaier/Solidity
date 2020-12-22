import "./Ownable.sol";
//import "./provableAPI.sol";

pragma solidity ^0.5.17;

contract CoinFlipper is Ownable{//add provable back on.

    uint256 private constant NUM_RANDOM_BYTES_REQUESTED = 1; //a number from 0-255
    uint256 private constant QUERY_EXECUTION_DELAY = 0;
    uint256 private constant GAS_FOR_CALLBACK = 200000;//first call is free, afterwards there is a fee
    uint256 public jackpot = 50;
    uint256 public balance;
    uint256 public minimumBet = 0.01 ether;
    uint256 public houseProfit = 1;

    event logNewProvableQuery(address caller, bytes32 queryId, string desription);
    event generatedRandomNumber(uint256 randomNumber);
    event flipResult(address player, bytes32 queryId, uint256 amount, bool won);
    event error(string destription);
    event withdrawal(uint256 amount);
    event deposit(uint256 amount);

    struct bet {
        address player;
        uint256 stake;
    }

    mapping(bytes32 => bet) public pendingBets; //players that wait for callback of oracle
    mapping(address => uint256) public balancesForCollection;//player's balance

    modifier costs(uint256 cost){
        require(msg.value >= cost, "insufficient funds");
        _;
    }

    constructor() public payable {
        balance = msg.value;
    }

    //constructor() public {
    //    provable_setProof(proofType_Ledger);
    //}

    function flipCoin() public payable costs(0.01 ether) returns (uint256) {
        uint256 result = now % 2;
    return result;
    }
    
    function payout(uint256 _amount, address payable _to) public payable returns(uint256){
        require(jackpot >= _amount, "Insufficient funds in contract");//checks
        uint256 toTransfer = _amount;
        jackpot = jackpot - toTransfer;//effects
        _to.transfer(toTransfer);//interactions
        return toTransfer;
    }
    
    function fundContract(uint256 _amount) public payable {
        require(_amount >= 0);
        jackpot = jackpot + _amount;
        emit deposit(_amount);
    }




}