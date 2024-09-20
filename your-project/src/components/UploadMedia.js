import React, { useState } from 'react';
import { create as ipfsClient } from 'ipfs-http-client';

const client = ipfsClient('https://ipfs.infura.io:5001');

const UploadMedia = () => {
    const [file, setFile] = useState(null);
    const [price, setPrice] = useState('');

    const uploadFile = async (event) => {
        event.preventDefault();

        if (!file) return;

        const added = await client.add(file);
        const ipfsHash = added.path;

        // Call smart contract method to mint NFT with ipfsHash and price
        console.log("File uploaded to IPFS:", ipfsHash);
    };

    return (
        <form onSubmit={uploadFile}>
            <input type="file" onChange={(e) => setFile(e.target.files[0])} required />
            <input
                type="text"
                placeholder="Set Price in Tokens"
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                required
            />
            <button type="submit">Upload and Mint NFT</button>
        </form>
    );
};

export default UploadMedia;
