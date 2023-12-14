
impor NFTStorefrontV2 dari  0x4eb8a10cb9f87357
impor NonFungibleToken dari  0x1d7e57aa55817448
impor FlowversePass dari  0x9212a87501a8a6a2
impor FlowverseTreasures dari  0x9212a87501a8a6a2
impor MetadataViews dari  0x1d7e57aa55817448

transaksi {
    persiapkan ( akun : AuthAccount) {
        jika acct.borrow < &FlowversePass.Collection > ( dari : FlowversePass.CollectionStoragePath) ==  nihil {
            menurut. simpan ( <- FlowversePass.createEmptyCollection (), ke : FlowversePass.CollectionStoragePath)
            acct.link < &FlowversePass.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, FlowversePass.CollectionPublic, MetadataViews.ResolverCollection} > (FlowversePass.CollectionPublicPath, target: FlowversePass.CollectionStoragePath)
        }
        jika acct.pinjam < &FlowverseTreasures.Collection > ( dari : FlowverseTreasures.CollectionStoragePath) ==  nihil {
            menurut. simpan ( <- FlowverseTreasures.createEmptyCollection (), ke : FlowverseTreasures.CollectionStoragePath)
            acct.link < &FlowverseTreasures.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, FlowverseTreasures.CollectionPublic, MetadataViews.ResolverCollection} > (FlowverseTreasures.CollectionPublicPath, target: FlowverseTreasures.CollectionStoragePath)
        }
        jika acct.borrow < &NFTStorefrontV2.Storefront > ( dari : NFTStorefrontV2.StorefrontStoragePath) ==  nihil {
            biarkan  etalase <- NFTStorefrontV2. buatStorefront () sebagai ! @NFTStorefrontV2.Storefront
            menurut. simpan ( <- etalase, ke : NFTStorefrontV2.StorefrontStoragePath)
            acct.link < &NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic} > (NFTStorefrontV2.StorefrontPublicPath, target: NFTStorefrontV2.StorefrontStoragePath)
        }
    }
  }
