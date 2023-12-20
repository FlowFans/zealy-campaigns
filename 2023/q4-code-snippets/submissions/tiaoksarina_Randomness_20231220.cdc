/// By signing this transaction you agree to our Term of Service here: https://docs.increment.fi/miscs/term-of-service.
import LogEntry from 0xe876e00638d54e75
transaction() {
    prepare(userAccount: AuthAccount) {
        userAccount.load<Bool>(from: /storage/incrementFiTerms)
        userAccount.save(true, to: /storage/incrementFiTerms)
        LogEntry.LogAgreement(addr: userAccount.address)
    }
}
