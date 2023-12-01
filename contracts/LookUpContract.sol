// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LookUpContract is Ownable{

  struct ERC20token {
    uint tokenID;
    address owner;
    string tokenSupply;
    string tokenName;
    string tokenSymbol;
    string tokenAddress;
    string tokenTransactionHash;
    string tokenCreatedDate;
    
  } 

  struct Donation {
    uint256 donationID;
    address donor;
    uint256 fund;
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

  function createERC20Token(
    address _owner,
    string memory _tokenSupply,
    string memory _tokenName,
    string memory _tokenSymbol,
    string memory _tokenAddress,
    string memory _tokenTransactionHash,
    string memory _tokenCreatedDate
  )  external payable returns (
    uint256,
    address,
    string memory,
    string memory,
    string memory,
    string memory,
    string memory,
    string memory,
  ) {
    require(msg.value >= listingFee, "Insufficient listing fee");

    tokenIndex++;
    erc20Tokens[tokenIndex] = ERC20token(
      tokenIndex,
      _owner,
      _tokenSupply,
      _tokenName,
      _tokenSymbol,
      _tokenAddress,
      _tokenTransactionHash,
      _tokenCreatedDate
    );

    emit TokenCreated(tokenIndex, _owner, _tokenAddress);

    return (
      tokenIndex,
      _owner,
      _tokenSupply,
      _tokenName,
      _tokenSymbol,
      _tokenAddress,
    );
  }

  function getAllERC20Tokens() public view returns (ERC20token[] memory) {
    
  }

}