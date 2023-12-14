import NonFungibleToken from 0x631e88ae7f1d7c20
import ExampleNFT from 0x2bd9d8989a3352a1

/// Mints a new ExampleNFT into recipient's account
transaction(recipient: Address) {
  /// Reference to the receiver's collection
  let recipientCollectionRef: &amp;{NonFungibleToken.CollectionPublic}

  /// Previous NFT ID before the transaction executes
  let mintingIDBefore: UInt64

  prepare(signer: AuthAccount) {
    self.mintingIDBefore = ExampleNFT.totalSupply

    // Borrow the recipient's public NFT collection reference
    self.recipientCollectionRef = getAccount(recipient)
      .getCapability(ExampleNFT.CollectionPublicPath)
      .borrow&lt;&amp;{NonFungibleToken.CollectionPublic}&gt;()
      ?? panic(&quot;Could not get receiver reference to the NFT Collection&quot;)
  }

  execute {
    let currentIDString = self.mintingIDBefore.toString()

    // Mint the NFT and deposit it to the recipient's collection
    ExampleNFT.mintNFT(
      recipient: self.recipientCollectionRef,
      name: &quot;Example NFT #&quot;.concat(currentIDString),
      description: &quot;Example description for #&quot;.concat(currentIDString),
      thumbnail: &quot;https://robohash.org/&quot;.concat(currentIDString),
      royalties: []
    )
  }

  post {
    self.recipientCollectionRef.getIDs().contains(self.mintingIDBefore): &quot;The next NFT ID should have been minted and delivered&quot;
    ExampleNFT.totalSupply == self.mintingIDBefore + 1: &quot;The total supply should have been increased by 1&quot;
  }
}

import HelloWorld from 0x9dca641e9a4b691b

pub fun main(): String {
  return HelloWorld.greeting
}

pub contract HelloWorld {
  pub var greeting: String

  access(account) fun changeGreeting(newGreeting: String) {
    self.greeting = newGreeting
  }

  init() {
    self.greeting = &quot;Hello, World!&quot;
  }
}
