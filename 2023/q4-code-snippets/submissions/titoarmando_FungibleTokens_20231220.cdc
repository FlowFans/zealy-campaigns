
      import FungibleToken from 0xf233dcee88fe0abe
      transaction(amount: UFix64, to: Address) {
      let vault: @FungibleToken.Vault
      prepare(signer: AuthAccount) {
      self.vault <- signer
      .borrow<&{FungibleToken.Provider}>(from: /storage/flowTokenVault)!
      .withdraw(amount: amount)
      }
      execute {
      getAccount(to)
      .getCapability(/public/flowTokenReceiver)!
      .borrow<&{FungibleToken.Receiver}>()!
      .deposit(from: <-self.vault)
      }
      }
