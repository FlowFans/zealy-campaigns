pub contract Test {
   pub resource NFT {
      pub let id: UInt64
      pub let rarity: String
      pub var name: String

      init(rarity: String, name: String) {
         self.id = self.uuid
         self.rarity = rarity
         self.name = name
      }
   }

   pub fun createNFT(rarity: String, name: String): @NFT {
      let nft <- create NFT(rarity: rarity, name: name)
      return <- nft
   }
}
