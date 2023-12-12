let collectionRef = account.borrow<&ExampleNFT.Collection>(from: /storage/ExampleNFTCollection)
    ?? panic("Could not borrow a reference to the owner's collection")

// withdraw the NFT from the owner's collection
let nft <- collectionRef.withdraw(withdrawID: 42)
