import HybridCustody from 0xd8a7e05a7ac670c0

transaction(parent: Address) {
    prepare (acct: AuthAccount) {
        let ownedAccount = acct.borrow<&HybridCustody.OwnedAccount>(from: HybridCustody.OwnedAccountStoragePath)
            ?? panic("owned account not found")
        ownedAccount.removeParent(addr: parent)
    }
}
