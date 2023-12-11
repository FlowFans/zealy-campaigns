
                import NFL from 0x8f3e345219de6fed
                import NonFungibleToken from 0x1d7e57aa55817448
                transaction {
                    prepare(acct: AuthAccount) {

                        // Create a new empty collection
                        let collection <- NFL.createEmptyCollection()

                        // store the empty NFT Collection in account storage
                        acct.save<@NonFungibleToken.Collection>(<-collection, to: /storage/NFLCollection)

                        log("Collection created for account 1")

                        // create a public capability for the Collection
                        // acct.link<&{NonFungibleToken.CollectionPublic}>(/public/NFLCollection, target: /storage/NFLCollection)
                        acct.link<&NFL.Collection{NonFungibleToken.CollectionPublic, NFL.NFLCollectionPublic}>(NFL.CollectionPublicPath, target: NFL.CollectionStoragePath)
                        log("Capability created")

                        // do not add below, as you cannot create resource type outside of containing contract (throws error)
                        // acct.save(<-create NFL.NFTMinter(), to: NFL.MinterStoragePath)
                    }
                }
