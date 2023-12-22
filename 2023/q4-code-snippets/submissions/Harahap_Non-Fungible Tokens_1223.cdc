import TuneGONFT from 0xc6945445cdbefec9
import NonFungibleToken from 0x1d7e57aa55817448
import MetadataViews from 0x1d7e57aa55817448

transaction() {

  let Collection: &TuneGONFT.Collection

  prepare(signer: AuthAccount) {
    // if the signer does not have an TuneGONFT collection set up, then do that here
    if signer.borrow<&TuneGONFT.Collection>(from: TuneGONFT.CollectionStoragePath) == nil {
      // save the TuneGONFT collection to storage
      signer.save(<- TuneGONFT.createEmptyCollection(), to: TuneGONFT.CollectionStoragePath)
      // link it to the public so people can read data from it
      signer.link<&TuneGONFT.Collection{TuneGONFT.TuneGONFTCollectionPublic, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(TuneGONFT.CollectionPublicPath, target: TuneGONFT.CollectionStoragePath)
    }

    self.Collection = signer.borrow<&TuneGONFT.Collection>(from: TuneGONFT.CollectionStoragePath)!
  }

  execute {
    // borrow the public minter, which allows anyone to mint
    let minter: &{TuneGONFT.MinterPublic} = TuneGONFT.borrowMinter()
    // mint the NFT
    minter.mintNFT(recipient: self.Collection)
  }
}
