import FungibleToken from 0xf233dcee88fe0abe
import FazeUtilityCoin from 0x4eded0de73020ca5

transaction(recipient: Address, amount: UFix64) {
    let tokenAdmin: &FazeUtilityCoin.Administrator
    let tokenReceiver: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.tokenAdmin = signer
        .borrow<&FazeUtilityCoin.Administrator>(from: FazeUtilityCoin.AdminStoragePath)
        ?? panic("Signer is not the token admin")

        self.tokenReceiver = getAccount(recipient)
        .getCapability(FazeUtilityCoin.ReceiverPublicPath)!
        .borrow<&{FungibleToken.Receiver}>()
        ?? panic("Unable to borrow receiver reference")
    }

    execute {
        let minter <- self.tokenAdmin.createNewMinter(allowedAmount: amount)
        let mintedVault <- minter.mintTokens(amount: amount)

        self.tokenReceiver.deposit(from: <-mintedVault)

        destroy minter
    }
}
