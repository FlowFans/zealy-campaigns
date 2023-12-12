import ExampleNFT from "0xd96c4bfc8cb59186"
import MetadataViews from "0xd96c4bfc8cb59186"

// ...

// Get the regular public capability
let collection = account.getCapability(ExampleNFT.CollectionPublicPath)
    .borrow<&{ExampleNFT.ExampleNFTCollectionPublic}>()
    ?? panic("Could not borrow a reference to the collection")

// Borrow a reference to the NFT as usual
let nft = collection.borrowExampleNFT(id: 42)
    ?? panic("Could not borrow a reference to the NFT")

// Call the resolveView method
// Provide the type of the view that you want to resolve
// View types are defined in the MetadataViews contract
// You can see if an NFT supports a specific view type by using the `getViews()` method
if let view = nft.resolveView(Type<MetadataViews.Display>()) {
    let display = view as! MetadataViews.Display

    log(display.name)
    log(display.description)
    log(display.thumbnail)
}

// The owner is stored directly on the NFT object
let owner: Address = nft.owner!.address!

// Inspect the type of this NFT to verify its origin
let nftType = nft.getType()

// `nftType.identifier` is `A.e03daebed8ca0615.ExampleNFT.NFT`
