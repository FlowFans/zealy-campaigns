
  import AFLNFT from 0x8f9231920da9af6d
  import NonFungibleToken from 0x1d7e57aa55817448
  import FungibleToken from 0xf233dcee88fe0abe
  import FiatToken from 0xb19436aae4d94622

  transaction {
    prepare(signer: AuthAccount) {

      if signer.borrow<&AFLNFT.Collection>(from: AFLNFT.CollectionStoragePath) == nil {
        let collection <- AFLNFT.createEmptyCollection()
        signer.save<@NonFungibleToken.Collection>(<-collection, to: AFLNFT.CollectionStoragePath)
        signer.link<&{AFLNFT.AFLNFTCollectionPublic}>(AFLNFT.CollectionPublicPath, target: AFLNFT.CollectionStoragePath)
      }

      if signer.borrow<&FiatToken.Vault>(from: FiatToken.VaultStoragePath) == nil {
          signer.save(
              <-FiatToken.createEmptyVault(),
              to: FiatToken.VaultStoragePath
          )
          signer.link<&FiatToken.Vault{FungibleToken.Receiver}>(
              FiatToken.VaultReceiverPubPath,
              target: FiatToken.VaultStoragePath
          )
          signer.link<&FiatToken.Vault{FiatToken.ResourceId}>(
              FiatToken.VaultUUIDPubPath,
              target: FiatToken.VaultStoragePath
          )
          signer.link<&FiatToken.Vault{FungibleToken.Balance}>(
              FiatToken.VaultBalancePubPath,
              target: FiatToken.VaultStoragePath
          )
      }
    }
  }
