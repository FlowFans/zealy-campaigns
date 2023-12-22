
                import NFL from 0x8f3e345219de6fed
                import NonFungibleToken from 0x1d7e57aa55817448
                transaction(link: String, batch: UInt32, sequence: UInt16, limit: UInt16) {
                    let receiverRef: &{NonFungibleToken.CollectionPublic}
                    let minterRef: &NFL.NFTMinter
                    prepare(acct: AuthAccount) {
                        // Get the owner's collection capability and borrow a reference
                        self.receiverRef = acct.getCapability<&{NonFungibleToken.CollectionPublic}>(NFL.CollectionPublicPath)
                            .borrow()
                            ?? panic("Could not borrow receiver reference")
                        // Borrow a capability for the NFTMinter in storage
                        self.minterRef = acct.borrow<&NFL.NFTMinter>(from: NFL.MinterStoragePath)
                            ?? panic("could not borrow minter reference")
                    }
                    execute {
                        let newNFT <- self.minterRef.mintNFT(glink: link,gbatch: batch, glimit: limit, gsequence: sequence)
                        self.receiverRef.deposit(token: <-newNFT)
                        log("NFT Minted and deposited to Account 2's Collection")
                    }
                }
