pub contract ExampleToken {
pub var totalSupply: UFix64

pub resource interface Provider {
    pub fun withdraw(amount: UFix64): @Vault {
        post {
            // `result` refere-se ao valor de retorno da função
            result.balance == UFix64(amount):
                "O valor da retirada deve ser o mesmo que o saldo do Vault retirado"
        }
    }
}
pub resource interface Receiver {
    pub fun deposit(from: @Vault) {
        pre {
            from.balance > 0.0:
                "O saldo do depósito deve ser positivo"
        }
    }
}
pub resource interface Balance {
    pub var balance: UFix64
}
pub resource Vault: Provider, Receiver, Balance {

    pub var balance: UFix64
    init(balance: UFix64) {
        self.balance = balance
    }
    pub fun withdraw(amount: UFix64): @Vault {
        self.balance = self.balance - amount
        return <-create Vault(balance: amount)
    }
    pub fun deposit(from: @Vault) {
        self.balance = self.balance + from.balance
        destroy from
    }
}
pub fun createEmptyVault(): @Vault {
    return <-create Vault(balance: 0.0)
}
pub resource VaultMinter {
    pub fun mintTokens(amount: UFix64, recipient: Capability<&AnyResource{Receiver}>) {
        let recipientRef = recipient.borrow()
            ?? panic("Não foi possível pegar uma referência do receptor para o vault")

        ExampleToken.totalSupply = ExampleToken.totalSupply + UFix64(amount)
        recipientRef.deposit(from: <-create Vault(balance: amount))
    }
}
init() {
    self.totalSupply = 30.0
    let vault <- create Vault(balance: self.totalSupply)
    self.account.save(<-vault, to: /storage/CadenceFungibleTokenTutorialVault)
    self.account.save(<-create VaultMinter(), to: /storage/CadenceFungibleTokenTutorialMinter)
    self.account.link<&VaultMinter>(/private/Minter, target: /storage/CadenceFungibleTokenTutorialMinter)
}
}
