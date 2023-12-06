import FLOATIncinerator from 0x2d4c3caffbeab845
import FLOAT from 0x2d4c3caffbeab845
     
transaction(id: UInt64) {
  let Collection: &FLOAT.Collection
  let Incinerator: &FLOATIncinerator.Incinerator


  prepare(signer: AuthAccount) {
    self.Collection = signer.borrow<&FLOAT.Collection>(from: FLOAT.FLOATCollectionStoragePath)
                          ?? panic("Could not get the Collection from the signer.")
   
    if signer.borrow<&FLOATIncinerator.Incinerator>(from: FLOATIncinerator.IncineratorStoragePath) == nil {
      signer.save(<- FLOATIncinerator.createIncinerator(), to: FLOATIncinerator.IncineratorStoragePath)
      signer.link<&FLOATIncinerator.Incinerator{FLOATIncinerator.IncineratorPublic}>(FLOATIncinerator.IncineratorPublicPath, target: FLOATIncinerator.IncineratorStoragePath)
    }
    self.Incinerator = signer.borrow<&FLOATIncinerator.Incinerator>(from: FLOATIncinerator.IncineratorStoragePath)!
  }
 
  execute {
    self.Incinerator.burn(collection: self.Collection, ids: [id])
  }
}
