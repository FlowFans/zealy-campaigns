import MoxyClub from 0x0eb06cb2a7e9cff5

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
