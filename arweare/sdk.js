const Arweave = require('arweave');
const fs = require('fs');

// Initialize Arweave client
const arweave = Arweave.init({
    host: 'arweave.net', // Arweave host
    port: 443,           // Port
    protocol: 'https',   // Use https
});

// Load the wallet key file (JSON)
const wallet = JSON.parse(fs.readFileSync('D:\key.json', 'utf8'));

// Function to create and post a transaction
async function uploadData(data) {
    // Create a transaction
    let transaction = await arweave.createTransaction({
        data: data
    }, wallet);

    // Sign the transaction
    await arweave.transactions.sign(transaction, wallet);

    // Post the transaction
    let response = await arweave.transactions.post(transaction);

    console.log(`Transaction ID: ${transaction.id}`);
    return transaction.id;
}

// Example usage: Upload data to Arweave
uploadData('Hello, Arweave!');
