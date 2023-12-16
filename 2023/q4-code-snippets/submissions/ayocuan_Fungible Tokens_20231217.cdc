import ADHDToken from 0x4775491cf59852d3

transaction(
 projectId: String,
 cycleIndex: UInt64,
 reserveRate: UFix64,
 issuanceRate: UFix64
) {

 let Project: &ADHDToken.Project
  prepare(signer: AuthAccount) {
   let collection = signer.borrow<&ADHDToken.Collection>(from: ADHDToken.CollectionStoragePath)
                   ?? panic("A DAOTreasury doesn't exist here.")
   self.Project = collection.borrowProject(projectId: projectId) ?? panic("Project does not exist.")
 }

 execute {
   let cfc: ADHDToken.FundingCycleDetails = self.Project.getFundingCycle(cycleIndex: cycleIndex).details
   let details: ADHDToken.FundingCycleDetails = ADHDToken.FundingCycleDetails(
     cycleId: cfc.cycleId,
     fundingTarget: cfc.fundingTarget,  // unchanged
     issuanceRate: issuanceRate,
     reserveRate: reserveRate,
     timeframe: ADHDToken.CycleTimeFrame(cfc.timeframe.startTime, cfc.timeframe.endTime),  // unchanged
     payouts: cfc.payouts,
     allowOverflow: cfc.allowOverflow,
     allowedAddresses: cfc.allowedAddresses,
     catalogCollectionIdentifier: cfc.catalogCollectionIdentifier,
     cfc.extra
   )
   self.Project.editUpcomingCycle(cycleIndex: cycleIndex, details: details)
 }
}
