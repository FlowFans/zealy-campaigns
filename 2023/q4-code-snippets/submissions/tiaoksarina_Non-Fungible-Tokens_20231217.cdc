import NonFungibleToken from 0x1d7e57aa55817448
import KeeprItems from 0x5eb12ad3d5a99945
import MetadataViews from 0x1d7e57aa55817448

// This transaction transfers a Keepr Item from one account to another.

transaction(recipient: Address, withdrawID: UInt64) {
    prepare(signer: AuthAccount) {

        // get the recipients public account object
        let recipient = getAccount(recipient)

        // borrow a reference to the signer's NFT collection
        let collectionRef = signer.borrow<&KeeprItems.Collection>(from: KeeprItems.CollectionStoragePath)
            ?? panic("Could not borrow a reference to the owner's collection")

        // borrow a public reference to the receivers collection
        let depositRef = recipient.getCapability(KeeprItems.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>()!

        // withdraw the NFT from the owner's collection
        let nft <- collectionRef.withdraw(withdrawID: withdrawID)

        // Deposit the NFT in the recipient's collection
        depositRef.deposit(token: <-nft)
    }
}
