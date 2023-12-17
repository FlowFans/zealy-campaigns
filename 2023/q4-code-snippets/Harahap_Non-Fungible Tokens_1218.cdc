import BBxBarbieCard from 0xe5bf4d436ca23932

transaction(nftID: UInt64) {

  let Collection: &BBxBarbieCard.Collection

  prepare(signer: AuthAccount) {
    // borrow a reference to the signer's collection
    self.Collection = signer.borrow<&BBxBarbieCard.Collection>(from: BBxBarbieCard.CollectionStoragePath)
                        ?? panic("The signer does not have an BBxBarbieCard collection set up, and therefore no NFTs to burn.")
  }

  execute {
    // withdraw the nft from the collection
    let nft <- self.Collection.withdraw(withdrawID: nftID)

    // destroy, or "burn", the nft
    destroy nft
  }
}
