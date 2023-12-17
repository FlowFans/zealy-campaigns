
// Transfer script from blocto
import FungibleToken from 0xf233dcee88fe0abe
import FlowToken from 0x1654653399040a61
import BloctoStorageRent from 0x1dfd1e5b87b847dc

transaction(amount: UFix64, to: Address) {
  	let sentVault: @FungibleToken.Vault

	  let address: Address

  	prepare(signer: AuthAccount) {
    	  let vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
      		  ?? panic("Could not borrow reference to the owner's Vault!")

    	  self.sentVault <- vaultRef.withdraw(amount: amount)
		    self.address = signer.address
  	}

	  execute {
		    let recipient = getAccount(to)

		    let receiverRef = recipient.getCapability(/public/flowTokenReceiver).borrow<&{FungibleToken.Receiver}>()
		      ?? panic("Could not borrow receiver reference to the recipient's Vault")
	
			  receiverRef.deposit(from: <-self.sentVault)

		    BloctoStorageRent.tryRefill(self.address)
		    BloctoStorageRent.tryRefill(to)
  	}
}
