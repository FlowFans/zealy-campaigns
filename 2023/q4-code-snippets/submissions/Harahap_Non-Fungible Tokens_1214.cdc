import FLOAT from 0x2d4c3caffbeab845

// removes an NFT listing from FLOAT

transaction(listingResourceID: UInt64) {
    let storefront: &FLOAT.Storefront{FLOAT.StorefrontManager}

    prepare(acct: AuthAccount) {
        self.storefront = acct.borrow<&FLOAT.Storefront{FLOAT.StorefrontManager}>(from: FLOAT.StorefrontStoragePath)
            ?? panic("Missing or mis-typed FLOAT.Storefront resource")
    }

    execute {
        self.storefront.removeListing(listingResourceID: listingResourceID)
    }
}
