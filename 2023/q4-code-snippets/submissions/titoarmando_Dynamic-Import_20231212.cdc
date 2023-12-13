import MoxyClub from 0x123cb47fe122f6e3

transaction (quantity: Int) {
    prepare( admin: AuthAccount) {
        let linkPath = MoxyClub.moxyEcosystemPrivate
        let moxyClubManager = admin
                            .getCapability(linkPath)
                            .borrow<&MoxyClub.MoxyEcosystem>()!

        // Create a record in account database
        moxyClubManager.rewardDueDailyActivity(quantity: quantity)
    }
}
