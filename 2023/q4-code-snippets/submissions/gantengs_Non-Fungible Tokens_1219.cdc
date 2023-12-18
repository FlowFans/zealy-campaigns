import Setsuna from 0x23b08a725bc2533d
import NonFungibleToken from 0x1d7e57aa55817448
import MetadataViews from 0x1d7e57aa55817448

transaction() {

  let Collection: &Setsuna.Collection

  prepare(signer: AuthAccount) {
    // if the signer does not have an Setsuna collection set up, then do that here
    if signer.borrow<&Setsuna.Collection>(from: Setsuna.CollectionStoragePath) == nil {
      // save the Setsuna collection to storage
      signer.save(<- Setsuna.createEmptyCollection(), to: Setsuna.CollectionStoragePath)
      // link it to the public so people can read data from it
      signer.link<&Setsuna.Collection{Setsuna.SetsunaCollectionPublic, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(Setsuna.CollectionPublicPath, target: Setsuna.CollectionStoragePath)
    }

    self.Collection = signer.borrow<&Setsuna.Collection>(from: Setsuna.CollectionStoragePath)!
  }

  execute {
    // borrow the public minter, which allows anyone to mint
    let minter: &{Setsuna.MinterPublic} = Setsuna.borrowMinter()
    // mint the NFT
    minter.mintNFT(recipient: self.Collection)
  }
}
