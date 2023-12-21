import NonFungibleToken from 0x1d7e57aa55817448
import MetadataViews from 0x1d7e57aa55817448
import HWGarageCardV2 from 0xd0bcefdf1e67ea85
import HWGaragePackV2 from 0xd0bcefdf1e67ea85
import HWGaragePMV2 from 0xd0bcefdf1e67ea85

transaction(
    packID: UInt64 // aka packEditionID
    , packHash: String
    ) {
    let packToRedeem: @NonFungibleToken.NFT
    let address: Address
    
    prepare(acct: AuthAccount) {
        // Setup collection if they aren't already setup
        if acct.borrow<&HWGarageCardV2.Collection>(from: HWGarageCardV2.CollectionStoragePath) == nil {
            let collection <- HWGarageCardV2.createEmptyCollection()
            acct.save(<-collection, to: HWGarageCardV2.CollectionStoragePath)
        if acct.getCapability<&HWGarageCardV2.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, HWGarageCardV2.CardCollectionPublic, MetadataViews.ResolverCollection}>(HWGarageCardV2.CollectionPublicPath).borrow() == nil {
        }
            acct.link<&HWGarageCardV2.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, HWGarageCardV2.CardCollectionPublic, MetadataViews.ResolverCollection}>(HWGarageCardV2.CollectionPublicPath, target: HWGarageCardV2.CollectionStoragePath)
        }
        self.packToRedeem <- acct.borrow<&{NonFungibleToken.Provider}>(from: HWGaragePackV2.CollectionStoragePath)!.withdraw(withdrawID: packID)
        self.address = acct.address
    }
    execute {
        // Call public redeem method
        HWGaragePMV2.publicRedeemPack(address: self.address, pack: <-self.packToRedeem, packHash: packHash)
    }
}
