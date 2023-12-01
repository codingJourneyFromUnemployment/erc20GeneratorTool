// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract LookUpContract is Ownable, ReentrancyGuard{

  struct ERC20token {
    uint tokenID;
    address owner;
    uint256 tokenSupply;
    string tokenName;
    string tokenSymbol;
    address tokenAddress;
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
  event TokenCreated(uint256 indexed id, address indexed owner, address indexed tokenAddress);

  constructor() Ownable(msg.sender) {
    tokenIndex = 0;
    donationIndex = 0;
  }

  function createERC20Token(
    address _owner,
    uint256 _tokenSupply,
    string memory _tokenName,
    string memory _tokenSymbol,
    address _tokenAddress,
    string memory _tokenTransactionHash,
    string memory _tokenCreatedDate
  )  external payable returns (
    ERC20token memory
  ) {
    require(msg.value >= listingFee, "Insufficient listing fee");

    tokenIndex++;
    erc20Tokens[tokenIndex] = ERC20token(
      {
        tokenID: tokenIndex,
        owner: _owner,
        tokenSupply: _tokenSupply,
        tokenName: _tokenName,
        tokenSymbol: _tokenSymbol,
        tokenAddress: _tokenAddress,
        tokenTransactionHash: _tokenTransactionHash,
        tokenCreatedDate: _tokenCreatedDate
      }
    );

    emit TokenCreated(tokenIndex, _owner, _tokenAddress);

    return (
      erc20Tokens[tokenIndex]
    );
  }

  function getAllERC20Tokens() public view returns (ERC20token[] memory) {
    ERC20token[] memory tokenListedArr = new ERC20token[](tokenIndex);
    for(uint256 i = 0; i < tokenIndex; i++) {
      tokenListedArr[i] = erc20Tokens[i + 1];
    }
    return tokenListedArr;
  }

  function getERC20Token(uint256 _tokenIndex) external view returns (
    ERC20token memory
  ) {
    require(_tokenIndex > 0 && _tokenIndex <= tokenIndex, "Invalid token index");
    return (
      erc20Tokens[_tokenIndex]
    );
  }

  function getUserERC20Tokens(address _owner) external view returns (ERC20token[] memory) {
    uint256 userTokenCount = 0;
    for(uint256 i = 0; i < tokenIndex; i++) {
      if(erc20Tokens[i + 1].owner == _owner) {
        userTokenCount++;
      }
    }

    ERC20token[] memory userTokenArr = new ERC20token[](userTokenCount);
    for(uint256 i = 0; i < tokenIndex; i++) {
      if(erc20Tokens[i + 1].owner == _owner) {
        userTokenArr[i] = erc20Tokens[i + 1];
      }
    }

    return userTokenArr;
  }

  function getERC20TokenListingPrice() external view returns (uint256) {
    return listingFee;
  }

  function updateListingFee(uint256 _newListingFee) external onlyOwner {
    listingFee = _newListingFee;
  }

  function withdraw() external onlyOwner nonReentrant {
    require(address(this).balance > 0, "Insufficient balance");
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success, "Withdrawal failed");
  }

  function getContractBalance() external view onlyOwner returns (uint256) {
    return address(this).balance;
  }

  function donate() external payable {
    require(msg.value > 0, "Invalid donation amount");

    donationIndex++;
    donations[donationIndex] = Donation(
      {
        donationID: donationIndex,
        donor: msg.sender,
        fund: msg.value
      }
    );

    emit DonationReceived(msg.sender, msg.value);
  }

  function getAllDonations() external view onlyOwner returns (Donation[] memory) {
    Donation[] memory donationArr = new Donation[](donationIndex);

    for(uint256 i = 0; i < donationIndex; i++) {
      donationArr[i] = donations[i + 1];
    }

    return donationArr;
  }

}
