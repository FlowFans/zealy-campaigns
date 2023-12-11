
                import FEHVAsset from 0x964f3bf23a966563
                import NonFungibleToken from 0x6866cbb7f5a788d0
                transaction {
                    prepare(acct: AuthAccount) {

                        // Create a new empty collection
                        let collection <- FEHVAsset.createEmptyCollection()

                        // store the empty NFT Collection in account storage
                        acct.save<FEHVAsset.Collection>(<-collection, to: /storage/FEHVAssetCollection)

                        log("Collection created for account 1")

                        // create a public capability for the Collection
                        // acct.link<&{NonFungibleToken.CollectionPublic}>(/public/FEHVAsset, target: /storage/FEHVAssetCollection)
                        acct.link<&FEHVAsset.Collection{NonFungibleToken.CollectionPublic, FEHVAsset.FEHVAssetCollectionPublic}>(FEHVAsset.CollectionPublicPath, target: FEHVAsset.CollectionStoragePath)
                        log("Capability created")

                        // do not add below, as you cannot create resource type outside of containing contract (throws error)
                        // acct.save(<-create FEHVAsset.NFTMinter(), to: FEHVAsset.MinterStoragePath)
                   }
               }
