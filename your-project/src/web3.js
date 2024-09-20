import Web3 from 'web3';

const web3 = new Web3(window.ethereum);
const contractAddress = "YOUR_CONTRACT_ADDRESS";
const contractABI = []; // Your contract ABI here

export const contract = new web3.eth.Contract(contractABI, contractAddress);