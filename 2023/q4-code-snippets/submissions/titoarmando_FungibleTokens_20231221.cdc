import SloppyStakes from 0x53f389d96fb4ce5e
import FungibleToken from 0xf233dcee88fe0abe

transaction(recipient: Address, amount: UFix64) {

    let Vault: &SloppyStakes.Vault
    let Recipient: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.Vault = signer.borrow<&SloppyStakes.Vault>(from: SloppyStakes.VaultStoragePath)
                        ?? panic("Signer does not have a Sloppy Stakes Vault.")
        self.Recipient = getAccount(recipient).getCapability(SloppyStakes.ReceiverPublicPath)
                            .borrow<&{FungibleToken.Receiver}>()
                            ?? panic("Recipient does not have a receiver set up.")
    }

    execute {
        let vault: @FungibleToken.Vault <- self.Vault.withdraw(amount: amount)
        self.Recipient.deposit(from: <- vault)
    }
}
