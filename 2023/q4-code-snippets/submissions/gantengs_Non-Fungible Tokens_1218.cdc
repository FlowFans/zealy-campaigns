import NonFungibleToken from 0x1d7e57aa55817448
import DoodlesFans from 0x93582bb069ec57b5

// The person trasnferring the NFT is the one who signs this

transaction(nftIDs: [UInt64], recipients: [Address]) {

    // Reference to the withdrawer's collection
    let withdrawRef: &DoodlesFans.Collection

    prepare(signer: AuthAccount) {
        // borrow a reference to the signer's NFT collection
        self.withdrawRef = signer.borrow<&DoodlesFans.Collection>(from: DoodlesFans.CollectionStoragePath)
                ?? panic("Account does not store an object at the specified path")
    }

    execute {
        for i, nftID in nftIDs {
            // get recipient address for this nftID
            let recipient: Address = recipients[i]

            // Reference of the collection to deposit the NFT to
            let depositRef = getAccount(recipient).getCapability(DoodlesFans.CollectionPublicPath)
                                .borrow<&DoodlesFans.Collection{NonFungibleToken.CollectionPublic}>()
                                ?? panic("Could not borrow a reference to the receiver's collection")

            // withdraw the NFT from the owner's collection
            let nft <- self.withdrawRef.withdraw(withdrawID: nftID)

            // Deposit the NFT in the recipient's collection
            depositRef.deposit(token: <- nft)
        }
    }
}
