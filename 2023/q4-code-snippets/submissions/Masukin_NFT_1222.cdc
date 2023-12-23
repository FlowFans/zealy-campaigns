pub contract CryptoPoops {
  pub var totalSupply: UInt64

  pub resource NFT {
    pub let id: UInt64

    init() {
      self.id = self.uuid
    }
  }

  pub fun createNFT(): @NFT {
    return <- create NFT()
  }

  init() {
    self.totalSupply = 0
  }
}
