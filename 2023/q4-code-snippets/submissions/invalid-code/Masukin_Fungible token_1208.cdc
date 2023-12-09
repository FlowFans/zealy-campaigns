// FungibleToken.cdc

pub contract FungibleToken {

    // Token storage
    pub var totalSupply: UFix64
    pub var balances: {Address: UFix64}

    // Initialize the contract with an initial supply
    pub init() {
        self.totalSupply = 0.0
        self.balances = {}
    }

    // Mint new tokens and assign to an account
    pub fun mintTokens(to: Address, amount: UFix64) {
        require(amount > 0.0, "Amount must be greater than zero")

        self.totalSupply = self.totalSupply + amount
        self.balances[to] = (self.balances[to] ?? 0.0) + amount
    }

    // Transfer tokens from one account to another
    pub fun transferTokens(from: Address, to: Address, amount: UFix64) {
        require(amount > 0.0, "Amount must be greater than zero")
        let senderBalance = self.balances[from] ?? 0.0
        require(senderBalance >= amount, "Insufficient balance")

        self.balances[from] = senderBalance - amount
        self.balances[to] = (self.balances[to] ?? 0.0) + amount
    }

    // Get the balance of a specific account
    pub fun getBalance(account: Address): UFix64 {
        return self.balances[account] ?? 0.0
    }
}
