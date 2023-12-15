pub contract NFTExample {

    pub struct NFT {
        pub var id: UInt64
        pub var owner: Address
    }

    pub var collection: {UInt64: NFT}

    pub event NFTMinted(id: UInt64, owner: Address)

    pub fun mintNFT(): @ToNFTExample.NFT {
        let id = self.collection.length
        let nft = NFT(id: id, owner: self.account.address)
        self.collection[id] = nft
        emit NFTMinted(id: id, owner: self.account.address)
        return <-nft
    }

    pub fun getOwnerByID(id: UInt64): Address {
        return self.collection[id]?.owner
            ?? panic("NFT does not exist")
    }
}
