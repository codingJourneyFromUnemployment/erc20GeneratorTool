import React, {useState, useContext, createContext, useEffect} from "react";
import { ethers } from "ethers";
import Web3Modal from "web3modal";

import { 
  CheckIfWalletConnect, 
  connectWallet, 
  connectingWithContract, 
  getBalance, 
  connectingNativeTokenContract 
} from "../utils/index";

import { 
  ERC20Generator_ABI, 
  ERC20Generator_BYTECODE, 
  LookUpContract_ABI, 
  LookUpContract_BYTECODE 
} from "./constants";

const stateContext = createContext();

const stateContextProvider = ({children}) => {
  const [address, setAddress] = useState("");
  const [getAllERC20TokenListed, setGetAllERC20TokenListed] = useState([]);
  const [getUserERC20Tokens, setGetUserERC20Tokens] = useState([]);
  const [getAllDonation, setGetAllDonation] = useState([]);
  const [fee, setFee] = useState();
  const [balance, setBalance] = useState();
  const [mainBalance, setMainBalance] = useState();
  const [nativeToken, setNativeToken] = useState();

  const fetchInitialData = async () => {
    try {
      //get user account
      const account = await CheckIfWalletConnect();
      //get user balance
      const balance = await getBalance();
      setBalance(ethers.utils.formatEther(balance.toString()));
      setAddress(account);

      //native token
      const nativeTokenContract = await connectingNativeTokenContract();

      if(account){
        const nativeBalance = await nativeTokenContract.balanceOf(account);
        const nativeName = await nativeTokenContract.name();
        const nativeSymbol = await nativeTokenContract.symbol();
        const nativeDecimals = await nativeTokenContract.decimals();
        const nativeTotalSupply = await nativeTokenContract.totalSupply();
        const nativeAddress = await nativeTokenContract.getAddress();
        const nativeToken = {
          balance : ethers.utils.formatUnits(nativeBalance.toString(), "ether"),
          name : nativeName,
          address : nativeAddress,
          symbol : nativeSymbol,
          decimals : nativeDecimals,
          totalSupply : ethers.utils.formatUnits(nativeTotalSupply.toString(), "ether")
        };
        setNativeToken(nativeToken);

        console.log(nativeTokenContract);
      }

      //get contract
      const lookUpContract = await connectingWithContract();

      //if owner connect, get contract balance
      if (account == process.env.OWNER_ADDRESS) {
        const contractBalance = await lookUpContract.getContractBalance();
        const mainBal = ethers.utils.formatUnits(
          contractBalance.toString(),
          "ether"
        );
        
        console.log(mainBal);
        setMainBalance(mainBal);
      }

      //get all ERC20 token
      const getAllERC20TokenListed = await lookUpContract.getAllERC20Tokens();

      //
      const parsedToken = getAllERC20TokenListed.map()
    } catch (error) {
      
    }
  }
}