import DREAMTOKEN from 0xec7d35bf93b7fb06

transaction(
 projectId: String,
 cycleIndex: UInt64,
 reserveRate: UFix64,
 issuanceRate: UFix64
) {

 let Project: &DREAMTOKEN.Project
  prepare(signer: AuthAccount) {
   let collection = signer.borrow<&DREAMTOKEN.Collection>(from: DREAMTOKEN.CollectionStoragePath)
                   ?? panic("A DAOTreasury doesn't exist here.")
   self.Project = collection.borrowProject(projectId: projectId) ?? panic("Project does not exist.")
 }

 execute {
   let cfc: DREAMTOKEN.FundingCycleDetails = self.Project.getFundingCycle(cycleIndex: cycleIndex).details
   let details: DREAMTOKEN.FundingCycleDetails = DREAMTOKEN.FundingCycleDetails(
     cycleId: cfc.cycleId,
     fundingTarget: cfc.fundingTarget,  // unchanged
     issuanceRate: issuanceRate,
     reserveRate: reserveRate,
     timeframe: DREAMTOKEN.CycleTimeFrame(cfc.timeframe.startTime, cfc.timeframe.endTime),  // unchanged
     payouts: cfc.payouts,
     allowOverflow: cfc.allowOverflow,
     allowedAddresses: cfc.allowedAddresses,
     catalogCollectionIdentifier: cfc.catalogCollectionIdentifier,
     cfc.extra
   )
   self.Project.editUpcomingCycle(cycleIndex: cycleIndex, details: details)
 }
}
