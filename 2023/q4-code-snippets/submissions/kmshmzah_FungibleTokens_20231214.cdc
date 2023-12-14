import FungibleToken from 0xf233dcee88fe0abe

transaction(amount: UFix64, to: Address) {
  let vault: @FungibleToken.Vault

  prepare(acct: AuthAccount) {
    self.vault <- acct
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
