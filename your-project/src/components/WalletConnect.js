import React, { useState } from 'react';
import Web3 from 'web3';

const WalletConnect = () => {
    const [account, setAccount] = useState('');

    const connectWallet = async () => {
        if (window.ethereum) {
            const web3 = new Web3(window.ethereum);
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            const accounts = await web3.eth.getAccounts();
            setAccount(accounts[0]);
        } else {
            alert('Please install MetaMask!');
        }
    };

    return (
        <div>
            <button onClick={connectWallet}>Connect Wallet</button>
            {account && <p>Connected: {account}</p>}
        </div>
    );
};

export default WalletConnect;