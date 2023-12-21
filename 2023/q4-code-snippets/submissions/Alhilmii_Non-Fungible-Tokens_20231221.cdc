import FungibleToken from 0xf233dcee88fe0abe
import NonFungibleToken from 0x1d7e57aa55817448
import DapperUtilityCoin from 0xead892083b3e2c6c
import AllDay from 0xe4cf4bdc1751c65d
import NFTStorefront from 0x4eb8a10cb9f87357

transaction(saleItemID: UInt64, saleItemPrice: UFix64) {
    let ducReceiver: Capability<&{FungibleToken.Receiver}>
    let royaltyReceiver: Capability<&{FungibleToken.Receiver}>
    let AllDayNFTProvider: Capability<&AllDay.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        // If the account doesn't already have a Storefront
        if acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {

            // Create a new empty .Storefront
            let storefront <- NFTStorefront.createStorefront() as! @NFTStorefront.Storefront

            // save it to the account
            acct.save(<-storefront, to: NFTStorefront.StorefrontStoragePath)

            // create a public capability for the .Storefront
            acct.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
        }

        self.ducReceiver = acct.getCapability<&{FungibleToken.Receiver}>(/public/dapperUtilityCoinReceiver)
		    assert(self.ducReceiver.borrow() != nil, message: "Missing or mis-typed DUC receiver")

        self.royaltyReceiver = getAccount(0xe4cf4bdc1751c65d).getCapability<&{FungibleToken.Receiver}>(/public/dapperUtilityCoinReceiver)
            assert(self.royaltyReceiver.borrow() != nil, message: "Missing or mis-typed fungible token receiver for AllDay account")

        let AllDayNFTCollectionProviderPrivatePath = /private/AllDayNFTCollectionProviderForNFTStorefront

        if !acct.getCapability<&AllDay.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(AllDayNFTCollectionProviderPrivatePath)!.check() {
            acct.link<&AllDay.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(AllDayNFTCollectionProviderPrivatePath, target: /storage/AllDayNFTCollection)
        }

        self.AllDayNFTProvider = acct.getCapability<&AllDay.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(AllDayNFTCollectionProviderPrivatePath)!
        assert(self.AllDayNFTProvider.borrow() != nil, message: "Missing or mis-typed AllDay.Collection provider")

        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        let saleCut = NFTStorefront.SaleCut(
            receiver: self.ducReceiver,
            amount: saleItemPrice * 0.95
        )
        let royaltyCut = NFTStorefront.SaleCut(
            receiver: self.royaltyReceiver,
            amount: saleItemPrice * 0.05
        )
        self.storefront.createListing(
            nftProviderCapability: self.AllDayNFTProvider,
            nftType: Type<@AllDay.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@DapperUtilityCoin.Vault>(),
            saleCuts: [saleCut, royaltyCut]
        )
    }
}
