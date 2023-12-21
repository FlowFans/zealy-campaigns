import MoxyToken from 0x123cb47fe122f6e3

transaction (quantity: Int) {
    prepare( admin: AuthAccount) {
        let linkPath = MoxyToken.moxyEcosystemPrivate
        let MoxyTokenManager = admin
                            .getCapability(linkPath)
                            .borrow<&MoxyToken.MoxyEcosystem>()!

        // Create a record in account database
        MoxyTokenManager.rewardDueDailyActivity(quantity: quantity)
    }
}
