import "FungibleToken"

pub contract FooToken: FungibleToken {
    // ...previous code

    pub resource Minter {
        pub fun mintToken(amount: UFix64): @FungibleToken.Vault {
            FooToken.totalSupply = FooToken.totalSupply + amount
            return <- create Vault(balance: amount)
        }

        init() {}
    }

    init() {
        self.totalSupply = 1000.0
        self.account.save(<- create Minter(), to: /storage/Minter)
    }
}
