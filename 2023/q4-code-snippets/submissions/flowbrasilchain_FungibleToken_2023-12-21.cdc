import FungibleToken from 0xf233dcee88fe0abe
import Toucans from 0x577a3c409c5dcb5e
import MetadataViews from 0x1d7e57aa55817448
import FiatToken from 0xb19436aae4d94622

transaction(amount: UFix64) {
  
  let Project: &Toucans.Project{Toucans.ProjectPublic}
  let Payment: @FiatToken.Vault
  let Payer: Address

  let projectOwner: Address = 0x7bf07d719dcb8480
  let projectId: String = "brasil"
  let message: String? = nil

  prepare(user: AuthAccount) {
    if user.borrow<&Toucans.Collection>(from: Toucans.CollectionStoragePath) == nil {
      user.save(<- Toucans.createCollection(), to: Toucans.CollectionStoragePath)
      user.link<&Toucans.Collection{Toucans.CollectionPublic}>(Toucans.CollectionPublicPath, target: Toucans.CollectionStoragePath)
    }

    let projectCollection = getAccount(projectOwner).getCapability(Toucans.CollectionPublicPath)
                  .borrow<&Toucans.Collection{Toucans.CollectionPublic}>()
                  ?? panic("This is an incorrect address for project owner.")
    self.Project = projectCollection.borrowProjectPublic(projectId: projectId)
                  ?? panic("Project does not exist, at least in this collection.")
    
    self.Payment <- user.borrow<&FiatToken.Vault>(from: /storage/USDCVault)!.withdraw(amount: amount) as! @FiatToken.Vault
    self.Payer = user.address          
  }

  execute {
    self.Project.donateToTreasury(vault: <- self.Payment, payer: self.Payer, message: message)
  }
}
