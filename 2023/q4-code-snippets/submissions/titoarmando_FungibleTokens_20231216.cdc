import FungibleToken from 0xf233dcee88fe0abe
import ScoreToken from 0x123cb47fe122f6e3

transaction(recipient: Address, amount: UFix64) {
    let tokenAdmin: &ScoreToken.Administrator

    prepare(signer: AuthAccount) {
        self.tokenAdmin = signer.borrow<&ScoreToken.Administrator>(from: ScoreToken.scoreTokenAdminStorage)
            ?? panic("Signer is not the token admin")

    }

    execute {
        let minter <- self.tokenAdmin.createNewMinter(allowedAmount: amount)
        minter.mintTokensTo(amount: amount, address: recipient)

        destroy minter
    }
}
