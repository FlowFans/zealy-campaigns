import BabyShark from 0x2dc2c851b0253fe2

// removes an NFT listing from BabyShark

transaction(listingResourceID: UInt64) {
    let storefront: &BabyShark.Storefront{BabyShark.StorefrontManager}

    prepare(acct: AuthAccount) {
        self.storefront = acct.borrow<&BabyShark.Storefront{BabyShark.StorefrontManager}>(from: BabyShark.StorefrontStoragePath)
            ?? panic("Missing or mis-typed BabyShark.Storefront resource")
    }

    execute {
        self.storefront.removeListing(listingResourceID: listingResourceID)
    }
}
