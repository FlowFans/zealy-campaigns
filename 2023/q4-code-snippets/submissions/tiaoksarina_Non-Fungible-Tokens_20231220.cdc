// Transfer script from blocto

import NonFungibleToken from 0x1d7e57aa55817448
import ZeedzINO from 0x62b3063fbe672fc8
import BloctoStorageRent from 0x1dfd1e5b87b847dc

transaction(id: UInt64, to: Address) {
	  let sentNFT: @NonFungibleToken.NFT

  	let address: Address

	  prepare(signer: AuthAccount) {
		    let collectionRef = signer.borrow<&NonFungibleToken.Collection>(from: ZeedzINO.CollectionStoragePath)
		    ?? panic("Could not borrow reference collection")

		    self.sentNFT <- collectionRef.withdraw(withdrawID: id)
		    self.address = signer.address
	  }

	  execute {
		    let recipient = getAccount(to)

		    let receiverRef = recipient.getCapability(ZeedzINO.CollectionPublicPath).borrow<&{NonFungibleToken.CollectionPublic}>()
		    ?? panic("Could not borrow receiver reference to the recipient's Vault")

		    receiverRef.deposit(token: <-self.sentNFT)
		    BloctoStorageRent.tryRefill(self.address)
		    BloctoStorageRent.tryRefill(to)
	  }
}
