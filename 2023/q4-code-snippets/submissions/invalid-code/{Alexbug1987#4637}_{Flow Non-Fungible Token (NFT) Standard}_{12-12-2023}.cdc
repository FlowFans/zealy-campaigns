let nft: ExampleNFT.NFT

// ...

let collection = account.getCapability(/public/ExampleNFTCollection)
    .borrow<&{NonFungibleToken.CollectionPublic}>()
    ?? panic("Could not borrow a reference to the receiver's collection")

collection.deposit(token: <-nft)
