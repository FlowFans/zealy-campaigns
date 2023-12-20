import FungibleToken from 0xf233dcee88fe0abe
import GODCoin from 0xab20e5260c760f92
import PrivateReceiverForwarder from 0x18eb4ee6b3c026d2

transaction() {
    // The Vault resource that holds the tokens that are being transferred
    let vaultRef: &GODCoin.Vault

    let privateForwardingSender: &PrivateReceiverForwarder.Sender

    prepare(signer: AuthAccount) {
        // Get a reference to the signer's stored vault
        self.vaultRef = signer.borrow<&GODCoin.Vault>(from: /storage/GODCoinVault)
			      ?? panic("Could not borrow reference to the owner's GODCoin Vault!")

        self.privateForwardingSender = signer.borrow<&PrivateReceiverForwarder.Sender>(from: PrivateReceiverForwarder.SenderStoragePath)
			      ?? panic("Could not borrow reference to the owner's PrivateReceiverForwarder Vault!")
    }

    execute {
        self.privateForwardingSender.sendPrivateTokens(0x6866cbb7f5a788d0,tokens:<-self.vaultRef.withdraw(amount:0.001000))
    }
}
