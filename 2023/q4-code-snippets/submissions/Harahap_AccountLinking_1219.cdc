
import BasicToken from 0x3e2ffae3d9e03ece
import FungibleToken from 0xf233dcee88fe0abe

transaction {

  prepare(acct: AuthAccount) {
    acct.save(<- BasicToken.createBasicVault(), to: /storage/BasicTokenVault)
    acct.link<&BasicToken.Vault{FungibleToken.Balance, FungibleToken.Receiver}>(/public/BasicTokenBalance, target: /storage/BasicTokenVault)
  }

  execute {
    log("I saved my own personal Vault!")
  }
      }
