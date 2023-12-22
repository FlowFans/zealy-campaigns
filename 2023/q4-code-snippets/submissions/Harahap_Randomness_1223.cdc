import DapperOffersV2 from 0xb8ea91944fd51c43

transaction(offerId: UInt64) {
    let dapperOffer: &DapperOffersV2.DapperOffer{DapperOffersV2.DapperOfferManager}

    prepare(acct: AuthAccount) {
        self.dapperOffer = acct.borrow<&DapperOffersV2.DapperOffer{DapperOffersV2.DapperOfferManager}>(from: DapperOffersV2.DapperOffersStoragePath)
            ?? panic("Missing or mis-typed DapperOffersV2.DapperOffer")
    }

    execute {
        self.dapperOffer.removeOffer(offerId: offerId)
    }
}
