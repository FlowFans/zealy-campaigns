    let factory = getAccount(factoryAddress).getCapability<&CapabilityFactory.Manager{CapabilityFactory.Getter}>(CapabilityFactory.PublicPath)
    assert(factory.check(), message: "factory address is not configured properly")

    let filter = getAccount(filterAddress).getCapability<&{CapabilityFilter.Filter}>(CapabilityFilter.PublicPath)
    assert(filter.check(), message: "capability filter is not configured properly")

    child.publishToParent(parentAddress: parent, factory: factory, filter: filter)
}
