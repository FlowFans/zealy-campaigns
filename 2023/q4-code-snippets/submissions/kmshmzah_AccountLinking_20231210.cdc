
import NFTStorefrontV2 from 0x4eb8a10cb9f87357
import NonFungibleToken from 0x1d7e57aa55817448
import FlowversePass from 0x9212a87501a8a6a2
import FlowverseTreasures from 0x9212a87501a8a6a2
import MetadataViews from 0x1d7e57aa55817448

transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&FlowversePass.Collection>(from: FlowversePass.CollectionStoragePath) == nil {
            acct.save(<- FlowversePass.createEmptyCollection(), to: FlowversePass.CollectionStoragePath)
            acct.link<&FlowversePass.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, FlowversePass.CollectionPublic, MetadataViews.ResolverCollection}>(FlowversePass.CollectionPublicPath, target: FlowversePass.CollectionStoragePath)
        }
        if acct.borrow<&FlowverseTreasures.Collection>(from: FlowverseTreasures.CollectionStoragePath) == nil {
            acct.save(<- FlowverseTreasures.createEmptyCollection(), to: FlowverseTreasures.CollectionStoragePath)
            acct.link<&FlowverseTreasures.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, FlowverseTreasures.CollectionPublic, MetadataViews.ResolverCollection}>(FlowverseTreasures.CollectionPublicPath, target: FlowverseTreasures.CollectionStoragePath)
        }
        if acct.borrow<&NFTStorefrontV2.Storefront>(from: NFTStorefrontV2.StorefrontStoragePath) == nil {
            let storefront <- NFTStorefrontV2.createStorefront() as! @NFTStorefrontV2.Storefront
            acct.save(<-storefront, to: NFTStorefrontV2.StorefrontStoragePath)
            acct.link<&NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}>(NFTStorefrontV2.StorefrontPublicPath, target: NFTStorefrontV2.StorefrontStoragePath)
        }
    }
}
