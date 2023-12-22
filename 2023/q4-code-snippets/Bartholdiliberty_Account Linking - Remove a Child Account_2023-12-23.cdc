import HybridCustody from 0xd8a7e05a7ac670c0

transaction(child: Address) {
    prepare (acct: AuthAccount) {
        let manager = acct.borrow<&HybridCustody.Manager>(from: HybridCustody.ManagerStoragePath)
            ?? panic("manager not found")
        manager.removeChild(addr: child)
    }
}
