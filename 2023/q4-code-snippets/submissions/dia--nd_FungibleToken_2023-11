import ADUToken from 0xe452a2f5665728f5
import FungibleToken from 0xf233dcee88fe0abe
import MetadataViews from 0x1d7e57aa55817448
import Toucans from 0x577a3c409c5dcb5e

transaction() {
  prepare(user: AuthAccount) {
    if user.borrow<&Toucans.Collection>(from: Toucans.CollectionStoragePath) == nil {
      user.save(<- Toucans.createCollection(), to: Toucans.CollectionStoragePath)
      user.link<&Toucans.Collection{Toucans.CollectionPublic}>(Toucans.CollectionPublicPath, target: Toucans.CollectionStoragePath)
    }

    if user.borrow<&ADUToken.Vault>(from: ADUToken.VaultStoragePath) == nil {
      user.save(<- ADUToken.createEmptyVault(), to: ADUToken.VaultStoragePath)
    }

    if user.getCapability(ADUToken.ReceiverPublicPath).borrow<&ADUToken.Vault{FungibleToken.Receiver}>() == nil {
      user.unlink(ADUToken.ReceiverPublicPath)
      user.link<&ADUToken.Vault{FungibleToken.Receiver}>(
          ADUToken.ReceiverPublicPath,
          target: ADUToken.VaultStoragePath
      )
    }

    if user.getCapability(ADUToken.VaultPublicPath).borrow<&ADUToken.Vault{FungibleToken.Balance, MetadataViews.Resolver}>() == nil {
      user.unlink(ADUToken.VaultPublicPath)
      user.link<&ADUToken.Vault{FungibleToken.Balance, MetadataViews.Resolver}>(
          ADUToken.VaultPublicPath,
          target: ADUToken.VaultStoragePath
      )
    }
  }
}
