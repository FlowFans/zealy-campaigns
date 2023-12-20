import TopShot from 0x0b2a3299cc857e29
import TopShotMarketV3 from 0xc1e4f4f4c4257510

transaction() {

	  let collectionRef: &TopShot.Collection
	  let momentIDs: [UInt64]

	  prepare(acct: AuthAccount) {
		    self.momentIDs = [UInt64(10092967)] as [UInt64]

		    // delist any of the moments that are listed (this delists for both MarketV1 and Marketv3)
		    if let topshotSaleV3Collection = acct.borrow<&TopShotMarketV3.SaleCollection>(from: TopShotMarketV3.marketStoragePath) {
			      for id in self.momentIDs {
				        if topshotSaleV3Collection.borrowMoment(id: id) != nil{
					          // cancel the moment from the sale, thereby de-listing it
					          topshotSaleV3Collection.cancelSale(tokenID: id)
			        	}
			      }
		    }

		    self.collectionRef = acct.borrow<&TopShot.Collection>(from: /storage/MomentCollection)
			      ?? panic("Could not borrow from MomentCollection in storage")
	  }

	  execute {
		    self.collectionRef.destroyMoments(ids: self.momentIDs)
	  }
}
