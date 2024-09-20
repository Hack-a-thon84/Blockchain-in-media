import React from 'react';
import WalletConnect from './WalletConnect';
import UploadMedia from './UploadMedia';
import MediaFeed from './MediaFeed';
import RatingSystem from './RatingSystem';

const App = () => {
    return (
        <div className="App">
            <header>
                <h1>Decentralized Media Platform</h1>
                <WalletConnect />
            </header>
            <main>
                <UploadMedia />
                <MediaFeed />
                <RatingSystem />
            </main>
        </div>
    );
};

export default App;