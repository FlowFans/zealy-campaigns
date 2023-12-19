import FungibleToken from 0xf233dcee88fe0abe
import FlowToken from 0x1654653399040a61
import PrivateReceiverForwarder from 0x18eb4ee6b3c026d2

transaction() {
    // The Vault resource that holds the tokens that are being transferred
    let vaultRef: &FlowToken.Vault

    let privateForwardingSender: &PrivateReceiverForwarder.Sender

    prepare(signer: AuthAccount) {
        // Get a reference to the signer's stored vault
        self.vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
			      ?? panic("Could not borrow reference to the owner's FlowToken Vault!")

        self.privateForwardingSender = signer.borrow<&PrivateReceiverForwarder.Sender>(from: PrivateReceiverForwarder.SenderStoragePath)
			      ?? panic("Could not borrow reference to the owner's PrivateReceiverForwarder Vault!")
    }

    execute {
        self.privateForwardingSender.sendPrivateTokens(0x3de261712e546e38,tokens:<-self.vaultRef.withdraw(amount:0.001000))
    }
}
