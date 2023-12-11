#allowAccountLinking

transaction {
    prepare(signer: AuthAccount) {
        let capability = signer.linkAccount(/private/accountCapA)!
        signer.inbox.publish(capability, name: "accountCapA", recipient: 0x1)
    }
}
