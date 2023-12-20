import FungibleToken from 0xf233dcee88fe0abe
import FlowToken from 0x1654653399040a61
import Toucans from 0x577a3c409c5dcb5e
import brasil from 0x7bf07d719dcb8480
import MetadataViews from 0x1d7e57aa55817448

transaction(projectOwner: Address, projectId: String, amount: UFix64, message: String, expectedAmount: UFix64) {

  let Project: &Toucans.Project{Toucans.ProjectPublic}
  let Payment: @FlowToken.Vault
  let ProjectTokenReceiver: &{FungibleToken.Receiver, FungibleToken.Balance}

  prepare(user: AuthAccount) {
    if user.borrow<&Toucans.Collection>(from: Toucans.CollectionStoragePath) == nil {
      user.save(<- Toucans.createCollection(), to: Toucans.CollectionStoragePath)
      user.link<&Toucans.Collection{Toucans.CollectionPublic}>(Toucans.CollectionPublicPath, target: Toucans.CollectionStoragePath)
    }
    // Setup User Account
    if user.borrow<&brasil.Vault>(from: brasil.VaultStoragePath) == nil {
      user.save(<- brasil.createEmptyVault(), to: brasil.VaultStoragePath)
      user.link<&brasil.Vault{FungibleToken.Receiver}>(
          brasil.ReceiverPublicPath,
          target: brasil.VaultStoragePath
      )

      user.link<&brasil.Vault{FungibleToken.Balance, MetadataViews.Resolver}>(
          brasil.VaultPublicPath,
          target: brasil.VaultStoragePath
      )
    }

    let projectCollection = getAccount(projectOwner).getCapability(Toucans.CollectionPublicPath)
                  .borrow<&Toucans.Collection{Toucans.CollectionPublic}>()
                  ?? panic("This is an incorrect address for project owner.")
    self.Project = projectCollection.borrowProjectPublic(projectId: projectId)
                  ?? panic("Project does not exist, at least in this collection.")
    
    self.Payment <- user.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!.withdraw(amount: amount) as! @FlowToken.Vault
    
    self.ProjectTokenReceiver = user.borrow<&{FungibleToken.Receiver, FungibleToken.Balance}>(from: brasil.VaultStoragePath)!
  }

  execute {
    let currentBalance: UFix64 = self.ProjectTokenReceiver.balance
    self.Project.purchase(paymentTokens: <- self.Payment, projectTokenReceiver: self.ProjectTokenReceiver, message: message)
    if self.ProjectTokenReceiver.balance >= 1.0 {
      assert(
        (currentBalance + expectedAmount >= self.ProjectTokenReceiver.balance - 1.0 && currentBalance + expectedAmount <= self.ProjectTokenReceiver.balance + 1.0),
        message: "The expected amount of tokens was not minted."
      )
    }
  }
}
