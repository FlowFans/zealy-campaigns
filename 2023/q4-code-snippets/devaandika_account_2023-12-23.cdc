transaction() {
    prepare(signer: AuthAccount) {
        // Get a key from an auth account.
        let keyA = signer.keys.get(keyIndex: 2)

        // Get a key from the public aacount.
        let publicAccount = getAccount(0x42)
        let keyB = publicAccount.keys.get(keyIndex: 2)
    }
}
