
        import FlowLottery from 0x62c176dfbc7497b6
        import FlowToken from 0x1654653399040a61

        transaction(amount: UFix64) {

            let Payment: @FlowToken.Vault
            let Buyer: Address

            prepare(signer: AuthAccount) {
                let flowVault = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!
                self.Payment <- flowVault.withdraw(amount: amount) as! @FlowToken.Vault
                self.Buyer = signer.address
            }

            execute {
                FlowLottery.buyTickets(address: self.Buyer, payment: <- self.Payment)
            }
        }
