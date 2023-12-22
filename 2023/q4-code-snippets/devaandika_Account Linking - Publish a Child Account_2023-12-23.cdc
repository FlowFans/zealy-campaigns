import FlowStakingCollection from 0x8d0e87b65159ae63

/// Commits rewarded tokens to stake for the specified node or delegator in the staking collection
transaction(nodeID: String, delegatorID: UInt32?, amount: UFix64) {

    let stakingCollectionRef: &FlowStakingCollection.StakingCollection

    prepare(account: AuthAccount) {
        self.stakingCollectionRef = account.borrow<&FlowStakingCollection.StakingCollection>(from: FlowStakingCollection.StakingCollectionStoragePath)
            ?? panic("Could not borrow ref to StakingCollection")
    }

    execute {
        self.stakingCollectionRef.stakeRewardedTokens(nodeID: nodeID, delegatorID: delegatorID, amount: amount)
    }
}
