import LendingAprSnapshot from 0x5da615e7385f307a
import LendingComptroller from 0xf80cb737bfe7c792
import LendingConfig from 0x2df970b6cdee5735
import LendingInterfaces from 0x2df970b6cdee5735

// Bot periodically sample all lending markets' apr data and store them on-chain. 
transaction() {
    prepare(bot: AuthAccount) {
        let comptrollerRef = getAccount(LendingComptroller.comptrollerAddress).getCapability<&{LendingInterfaces.ComptrollerPublic}>(LendingConfig.ComptrollerPublicPath).borrow()
            ?? panic("cannot borrow reference to ComptrollerPublic")

        let poolArrays = comptrollerRef.getAllMarkets()
        for poolAddr in poolArrays {
            let sampled = LendingAprSnapshot.sample(poolAddr: poolAddr)
            getAccount(poolAddr).getCapability<&{LendingInterfaces.PoolPublic}>(/public/incrementLendingPoolPublic).borrow()!.accrueInterest()
        }
    }
}
