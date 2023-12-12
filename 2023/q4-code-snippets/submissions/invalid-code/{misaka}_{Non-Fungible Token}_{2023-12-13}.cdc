let collection <- ExampleNFT.createEmptyCollection()

account.save(<-collection, to: /storage/ExampleNFTCollection)

// create a public capability for the collection
account.link<&{NonFungibleToken.CollectionPublic}>(
    /public/ExampleNFTCollection,
    target: /storage/ExampleNFTCollection
)
