import FungibleToken from 0xf233dcee88fe0abe
import DapperUtilityCoin from 0xead892083b3e2c6c
import TopShot from 0x0b2a3299cc857e29
import Market from 0xc1e4f4f4c4257510
import TopShotMarketV3 from 0xc1e4f4f4c4257510

// This transaction purchases a moment from the v3 sale collection
// The v3 sale collection will also check the v1 collection for for sale moments as part of the purchase
// If there is no v3 sale collection, the transaction will just purchase it from v1 anyway

transaction() {

	  let purchaseTokens: @DapperUtilityCoin.Vault

	  prepare(acct: AuthAccount) {

		    // Borrow a provider reference to the buyers vault
		    let provider = acct.borrow<&DapperUtilityCoin.Vault{FungibleToken.Provider}>(from: /storage/dapperUtilityCoinVault)
			      ?? panic("Could not borrow a reference to the buyers FlowToken Vault")

		    // withdraw the purchase tokens from the vault
		    self.purchaseTokens <- provider.withdraw(amount: UFix64(18)) as! @DapperUtilityCoin.Vault

	  }

	  execute {

		    // get the accounts for the seller and recipient
		    let seller = getAccount(0x0c20128262a86457)
		    let recipient = getAccount(0x4b47a9a918e56439)

		    // Get the reference for the recipient's nft receiver
		    let receiverRef = recipient.getCapability(/public/MomentCollection)!.borrow<&{TopShot.MomentCollectionPublic}>()
			      ?? panic("Could not borrow a reference to the recipients moment collection")

		    if let marketV3CollectionRef = seller.getCapability(/public/topshotSalev3Collection)
				        .borrow<&{Market.SalePublic}>() {

			      let purchasedToken <- marketV3CollectionRef.purchase(tokenID: 30241630, buyTokens: <-self.purchaseTokens)
			      receiverRef.deposit(token: <-purchasedToken)

		    } else if let marketV1CollectionRef = seller.getCapability(/public/topshotSaleCollection)
			      .borrow<&{Market.SalePublic}>() {
			      // purchase the moment
			      let purchasedToken <- marketV1CollectionRef.purchase(tokenID: 30241630, buyTokens: <-self.purchaseTokens)

			      // deposit the purchased moment into the signer's collection
			      receiverRef.deposit(token: <-purchasedToken)

		    } else {
			      panic("Could not borrow reference to either Sale collection")
		    }
	  }
}
