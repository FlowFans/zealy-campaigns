import FungibleToken from 0xf233dcee88fe0abe
import FAHCoin from 0x76d988a29af9ea8d

transaction(recipients: [Address], amounts: [UFix64]) {

    let vaultRef: &FAHCoin.Vault

    prepare(signer: AuthAccount) {
        // Get a reference to the signer's stored vault
        self.vaultRef = signer.borrow<&FAHCoin.Vault>(from: /storage/FAHCoinVault)
            ?? panic("Could not borrow reference to the owner's Vault!")
    }

    pre {
        recipients.length == amounts.length: "invalid params"
    }

    execute {
        var counter = 0

        while (counter < recipients.length) {
            // Get the recipient's public account object
            let recipientAccount = getAccount(recipients[counter])

            // Get a reference to the recipient's Receiver
            let receiverRef = recipientAccount.getCapability(/public/FAHCoinReceiver)!
                .borrow<&{FungibleToken.Receiver}>()
                ?? panic("Could not borrow receiver reference to the recipient's Vault")

            // Deposit the withdrawn tokens in the recipient's receiver
            receiverRef.deposit(from: <-self.vaultRef.withdraw(amount: amounts[counter]))

            counter = counter + 1
        }
    }
}
