transaction {
    prepare(signer: AuthAccount) {
        let capability = signer.inbox.claim<&AuthAccount>("accountCapB", provider: 0x2)!
        let accountRef = capability.borrow()!
    }
}
