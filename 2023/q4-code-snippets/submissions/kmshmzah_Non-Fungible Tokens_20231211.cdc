
                import BLUES from 0x058ab2d5d9808702
                import NonFungibleToken from 0x1d7e57aa55817448
                transaction {
                    prepare(acct: AuthAccount) {

                        // Create a new empty collection
                        let collection <- BLUES.createEmptyCollection()

                        // store the empty NFT Collection in account storage
                        acct.save<@BLUES.Collection>(<-collection, to: /storage/BLUESCollection)

                        log("Collection created for account 1")

                        // create a public capability for the Collection
                        // acct.link<&{NonFungibleToken.CollectionPublic}>(/public/BLUESCollection, target: /storage/BLUESCollection)
                        acct.link<&BLUES.Collection{NonFungibleToken.CollectionPublic, BLUES.BLUESCollectionPublic}>(BLUES.CollectionPublicPath, target: BLUES.CollectionStoragePath)
                        log("Capability created")

                        // do not add below, as you cannot create resource type outside of containing contract (throws error)
                        // acct.save(<-create BLUES.NFTMinter(), to: BLUES.MinterStoragePath)
                    }
                }
