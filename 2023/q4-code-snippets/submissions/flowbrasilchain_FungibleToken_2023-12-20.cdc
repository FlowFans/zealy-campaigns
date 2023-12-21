import FungibleToken from 0xf233dcee88fe0abe
import brasil from 0x7bf07d719dcb8480
import Toucans from 0x577a3c409c5dcb5e

transaction {
    prepare(acct: AuthAccount) {
        // Verifica e configura o cofre brasil
        if acct.borrow<&brasil.Vault>(from: /storage/brasilVault) == nil {
            acct.save(<- brasil.createEmptyVault(), to: /storage/brasilVault)
            acct.link<&brasil.Vault{FungibleToken.Receiver}>(
                /public/brasilReceiver,
                target: /storage/brasilVault
            )
        }

        // Verifica e configura a coleção Toucans
        if acct.borrow<&Toucans.Collection>(from: Toucans.CollectionStoragePath) == nil {
            acct.save(<- Toucans.createCollection(), to: Toucans.CollectionStoragePath)
            acct.link<&Toucans.Collection{Toucans.CollectionPublic}>(
                Toucans.CollectionPublicPath,
                target: Toucans.CollectionStoragePath
            )
        }
    }

    execute {
    }
}
