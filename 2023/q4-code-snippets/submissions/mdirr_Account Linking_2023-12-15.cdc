import HybridCustody from 0x0eb06cb2a7e9cff5
import CapabilityFactory from 0x0eb06cb2a7e9cff5
import CapabilityFilter from 0x0eb06cb2a7e9cff5

transaction(parent: Address, factoryAddress: Address, filterAddress: Address) {
    prepare(acct: AuthAccount) {
        let child = acct.borrow<&HybridCustody.OwnedAccount>(from: HybridCustody.OwnedAccountStoragePath)
            ?? panic("child account not found")

        let factory = getAccount(factoryAddress).getCapability<&CapabilityFactory.Manager{CapabilityFactory.Getter}>(CapabilityFactory.PublicPath)
        assert(factory.check(), message: "factory address is not configured properly")

        let filter = getAccount(filterAddress).getCapability<&{CapabilityFilter.Filter}>(CapabilityFilter.PublicPath)
        assert(filter.check(), message: "capability filter is not configured properly")

        child.publishToParent(parentAddress: parent, factory: factory, filter: filter)
    }
}
