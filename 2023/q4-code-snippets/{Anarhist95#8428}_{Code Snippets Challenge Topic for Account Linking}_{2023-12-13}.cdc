#allowAccountLinking

transaction {
    prepare(signer: AuthAccount) {
        let capability = signer.linkAccount(/private/accountCapA)!
        signer.inbox.publish(capability, name: "accountCapA", recipient: 0x1)
    }
}
transaction {
    prepare(signer: AuthAccount) {
        let capability = signer.inbox.claim<&AuthAccount>("accountCapB", provider: 0x2)!
        let accountRef = capability.borrow()!
    }
}
