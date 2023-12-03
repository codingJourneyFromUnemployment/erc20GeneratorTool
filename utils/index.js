import { ethers } from "ethers"
import Web3Modal from "web3modal"

import {
  ERC20Generator_ABI,
  LookUpContract_ABI,
} from "../context/constants"

const CheckIfWalletConnect = async () => {
  try {
    if (!window.ethereum) {
      return console.log("Install Metamask")
    }
    const accounts = await window.ethereum.request({
      method: "eth_accounts",
    })
    if (accounts.length === 0) {
      return console.log("Please connect to MetaMask.");
    } else {
      const firstAccount = accounts[0];
      return firstAccount;
    }
  } catch (error) {
    console.log(error)
  }
}

const connectWallet = async () => {
  try {
    if (!window.ethereum) {
      return console.log("Install Metamask")
    }
    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    const firstAccount = accounts[0];
    return firstAccount;
  } catch (error) {
    console.log(error)
  }
}

const fetchContract = (signerOrProvider) => new ethers.Contract(
  process.env.LOOKUPCONTRACT_ADDRESS,
  LookUpContract_ABI,
  signerOrProvider
);

const connectingWithContract = async () => {
  try {
    const web3modal = new Web3Modal();
    const connection = await web3modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    const contract = fetchContract(signer);
    return contract;
  } catch (error) {
    console.log(error)
  }
}

const getBalance = async () => {
  try {
    const web3modal = new Web3Modal();
    const connection = await web3modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();

    return await signer.getBalance();
  } catch (error) {
    console.log(error)
  }
}

const fetchTokenContract = (signerOrProvider) => new ethers.Contract(
  process.env.ERC20GENERATOR_ADDRESS,
  ERC20Generator_ABI,
  signerOrProvider
);

const connectingNativeTokenContract = async () => {
  try {
    const web3modal = new Web3Modal();
    const connection = await web3modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    const contract = fetchTokenContract(signer);

    return contract;
  } catch (error) {
    console.log(error)
  }
}

export {CheckIfWalletConnect, connectWallet, connectingWithContract, getBalance, connectingNativeTokenContract}