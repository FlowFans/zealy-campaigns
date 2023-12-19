import NonFungibleToken from 0x1d7e57aa55817448
import FlowverseSocks from 0xce4c02539d1fabe8

// The person trasnferring the NFT is the one who signs this

transaction(recipient: Address, nftID: UInt64) {

    // Reference to the withdrawer's collection
    let withdrawRef: &FlowverseSocks.Collection

    // Reference of the collection to deposit the NFT to
    let depositRef: &FlowverseSocks.Collection{NonFungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        // borrow a reference to the signer's NFT collection
        self.withdrawRef = signer.borrow<&FlowverseSocks.Collection>(from: FlowverseSocks.CollectionStoragePath)
                ?? panic("Account does not store an object at the specified path")

        self.depositRef = getAccount(recipient).getCapability(FlowverseSocks.CollectionPublicPath)
                            .borrow<&FlowverseSocks.Collection{NonFungibleToken.CollectionPublic}>()
                            ?? panic("Could not borrow a reference to the receiver's collection")

    }

    execute {
        // withdraw the NFT from the owner's collection
        let nft <- self.withdrawRef.withdraw(withdrawID: nftID)

        // Deposit the NFT in the recipient's collection
        self.depositRef.deposit(token: <-nft)
    }
}
