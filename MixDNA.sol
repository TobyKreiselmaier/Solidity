pragma solidity ^0.5.12;

import "./Ownable.sol";
import "./Destroyable.sol";
import "./Safemath.sol";

contract CryptoBirdies is Ownable, Destroyable {

       function _mixDna(uint256 _dadDna, uint256 _mumDna) public view returns (uint256){
        uint256[9] memory geneArray;
        uint8 random = uint8(now % 255); //pseudorandom, real randomness doesn't exist in solidity and is redundant. This will return a number 0-255. e.g. 10111000
        uint8 randomSeventeenthDigit = uint8(now % 1);
        uint8 randomPair = uint8(now % 7); //w9d3 assignment. number to select random pair.
        uint8 randomNumberForRandomPair = uint8((now % 89) + 10);//value of random pair, making sure there's no leading '0'.
        uint256 i;
        uint256 counter = 7; // start on the right end

        //DNA example: 11 22 33 44 55 66 77 88 9

        if(randomSeventeenthDigit == 0){
            geneArray[8] = uint8(_mumDna % 10); //this takes the 17th gene from mum.
        } else {
            geneArray[8] = uint8(_dadDna % 10); //this takes the 17th gene from dad.
        }
        _mumDna = _mumDna / 10;                        
        _dadDna = _dadDna / 10;                        //division by 10 removes last digit from genes
        

        for (i = 1; i <= 128; i=i*2) {                      //1, 2 , 4, 8, 16, 32, 64 ,128
            if(random & i == 0){                            //00000001
                geneArray[counter] = uint8(_mumDna % 100);  //00000010 etc.
            } else {                                        //11001011 &
                geneArray[counter] = uint8(_dadDna % 100);  //00000001 will go through random number bitwise
            }                                               //if(1) - dad gene
            _mumDna = _mumDna / 100;                        //if(0) - mum gene
            _dadDna = _dadDna / 100;                        //division by 100 removes last two digits from genes
            counter = counter - 1;
        }

        geneArray[randomPair] = randomNumberForRandomPair; //extra randomness for random pair.

        uint256 newGene = 0;

        //geneArray example: [11, 22, 33, 44, 55, 66, 77, 88, 9]

        for (i = 0; i < 8; i++) {                           //8 is number of pairs in array
            newGene = newGene * 100;                        //adds two digits to newGene; no digits the first time
            newGene = newGene + geneArray[i];               //adds a pair of genes
        }
        newGene = newGene * 10;                             //add seventeenth digit
        newGene = newGene + geneArray[8];
        return newGene;
    }
}