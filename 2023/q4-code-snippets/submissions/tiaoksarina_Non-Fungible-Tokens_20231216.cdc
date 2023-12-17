import NFTStorefrontV2 from 0x4eb8a10cb9f87357

// generic NBA TopShot delist transaction

transaction(listingResourceID: UInt64) {
    let storefront: &NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontManager}

    prepare(acct: AuthAccount) {
        self.storefront = acct.borrow<&NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontManager}>(from: NFTStorefrontV2.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefrontV2.Storefront resource")
    }

    execute {
        self.storefront.removeListing(listingResourceID: listingResourceID)
    }
}
