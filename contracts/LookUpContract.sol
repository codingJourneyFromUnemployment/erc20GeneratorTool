// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LookUpContract is Ownable{

  struct ERC20token {
    uint tokenID,
    address owner,
    string tokenSupply,
    string tokenName,
    string tokenSymbol,
    string tokenAddress,
    string tokenTransactionHash,
    string tokenCreatedDate
    
  } 

  struct Donation {
    uint256 donationID,
    address donor,
    uint256 fund, 
  }

  uint256 public listingFee = 0.025 ether;
  mapping(uint256 => ERC20token) private erc20Tokens;
  mapping(uint256 => Donation) private donations;
  uint256 public tokenIndex;
  uint256 public donationIndex;

  event DonationReceived(address indexed _donor, uint256 _amount);
  event TokenCreated(uint256 indexed id, address indexed owner, string indexed token);

  constructor() Ownable(msg.sender) {
    tokenIndex = 0;
    donationIndex = 0;
  }

}