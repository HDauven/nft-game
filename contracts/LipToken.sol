// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LipToken is ERC721, Ownable {
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}
    
    uint256 COUNTER;
    
    uint256 fee = 1 ether;
    
    struct Lip {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }
    
    Lip[] public lips;
    
    event NewLip(address indexed owner, uint256 id, uint256 dna);
    
    // Helpers
    function _createRandomNumber(uint256 _mod) internal view returns(uint256) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        return randomNumber % _mod;
    }
    // function _generateRandomDna(string memory _str) internal pure returns(uint256) {
    //     uint256 randomNumber = uint256(keccak256(abi.encodePacked(_str)));
    //     return randomNumber % 10**16;
    // }
    
    function updateFee(uint256 _fee) external onlyOwner() {
        fee = _fee;
    }
    
    function withdraw() external payable onlyOwner() {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }
    
    // Creation
    function _createLip(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNumber(100));
        uint256 randomDna = _createRandomNumber(10**16);
        Lip memory newLip = Lip(_name, COUNTER, randomDna, 1, randRarity);
        lips.push(newLip);
        _safeMint(msg.sender, COUNTER);
        emit NewLip(msg.sender, COUNTER, randomDna);
        COUNTER++;
    }
    
    function createRandomLip(string memory _name) public payable {
        require(msg.value == fee, "The fee is not correct");
        _createLip(_name);
    }
    
    // Getters
    function getLips() public view returns(Lip[] memory) {
        return lips;
    }
}