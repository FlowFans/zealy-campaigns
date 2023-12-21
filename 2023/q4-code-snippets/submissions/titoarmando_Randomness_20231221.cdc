import OffersV2 from 0xb8ea91944fd51c43
import DapperOffersV2 from 0xb8ea91944fd51c43
import NonFungibleToken from 0x1d7e57aa55817448
import MetadataViews from 0x1d7e57aa55817448
import FungibleToken from 0xf233dcee88fe0abe
import DapperUtilityCoin from 0xead892083b3e2c6c

transaction(nftID: UInt64, offerId: UInt64, DapperOfferAddress: Address, storagePathIdentifier: String) {
    let dapperOffer: &DapperOffersV2.DapperOffer{DapperOffersV2.DapperOfferPublic}
    let offer: &OffersV2.Offer{OffersV2.OfferPublic}
    let receiverCapability: Capability<&{FungibleToken.Receiver}>
    prepare(signer: AuthAccount) {
        // Get the DapperOffers resource
        self.dapperOffer = getAccount(DapperOfferAddress)
            .getCapability<&DapperOffersV2.DapperOffer{DapperOffersV2.DapperOfferPublic}>(
                DapperOffersV2.DapperOffersPublicPath
            ).borrow()
            ?? panic("Could not borrow DapperOffer from provided address")
        // Set the fungible token receiver capabillity
        self.receiverCapability = signer.getCapability<&{FungibleToken.Receiver}>(/public/dapperUtilityCoinReceiver)
        assert(self.receiverCapability.borrow() != nil, message: "Missing or mis-typed DapperUtilityCoin receiver")
        // Get the DapperOffer details
        self.offer = self.dapperOffer.borrowOffer(offerId: offerId)
            ?? panic("No Offer with that ID in DapperOffer")

				let details = self.offer.getDetails()

        // Get the NFT resource and withdraw the NFT from the signers account
        let nftCollection = signer.borrow<&{NonFungibleToken.Provider}>(from: StoragePath(identifier: storagePathIdentifier)!)
            ?? panic("Cannot borrow NFT collection receiver from account")

		    let nft <- (nftCollection.withdraw(withdrawID: nftID) as! @AnyResource) as! @AnyResource{NonFungibleToken.INFT, MetadataViews.Resolver}

        self.offer.accept(
            item: <-nft,
            receiverCapability: self.receiverCapability
        )
    }
    execute {
        // delete the offer
        self.dapperOffer.cleanup(offerId: offerId)
    }
}
