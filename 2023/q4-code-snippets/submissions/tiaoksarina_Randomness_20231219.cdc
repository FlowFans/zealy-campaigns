import PDS from 0xb6f2481eba4df97b
import PackNFT from 0x0b2a3299cc857e29
import NonFungibleToken from 0x1d7e57aa55817448

transaction (distIds: [UInt64], commitHashes: [String], issuer: Address, receiver: Address) {
    prepare(pds: AuthAccount) {
        for i, distId in distIds {
            let recvAcct = getAccount(receiver)
            let recv = recvAcct.getCapability(PackNFT.CollectionPublicPath).borrow<&{NonFungibleToken.CollectionPublic}>()
                ?? panic("Unable to borrow Collection Public reference for recipient")
            let cap = pds.borrow<&PDS.DistributionManager>(from: PDS.DistManagerStoragePath) ?? panic("pds does not have Dist manager")
            cap.mintPackNFT(distId: distId, commitHashes: [commitHashes[i]], issuer: issuer, recvCap: recv)
        }
    }
}
