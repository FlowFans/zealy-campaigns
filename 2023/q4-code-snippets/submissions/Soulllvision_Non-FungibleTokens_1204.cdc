// Definition of the NFT asset
pub resource NFT {
    pub let id: UInt64
    pub var owner: Address
    pub var realEstateID: UInt64
}

// Definition of the real estate asset
pub resource RealEstate {
    pub let id: UInt64
    pub var owner: Address
    pub var details: String
}

// Smart contract
pub contract NFTRealEstateContract {

    // Create an NFT with a link to real estate
    pub fun createNFTWithRealEstate(realEstateID: UInt64): @NFT {
        // Check ownership of the real estate
        let realEstate = getRealEstateByID(realEstateID: realEstateID)
        assert(realEstate.owner == getAccountAddress(), message: "You don't own this real estate.")

        // Create a new NFT
        let newNFT <- create NFT(id: self.account.borrow<&NFT.Collection>().borrowNewID(), owner: self.account.address, realEstateID: realEstateID)

        // Transfer ownership of the NFT
        self.account.save(<-newNFT, to: NFTStoragePath)

        return <-newNFT as! @NFT
    }

    // Get information about real estate by ID
    pub fun getRealEstateByID(realEstateID: UInt64): @RealEstate? {
        return getAccountStorage<@RealEstate>(from: RealEstateStoragePath(id: realEstateID))
    }

    // Path for storing NFTs
    pub let NFTStoragePath: StoragePath = /storage/NFTs

    // Path for storing real estate
    pub let RealEstateStoragePath: StoragePath = /storage/RealEstates
}
