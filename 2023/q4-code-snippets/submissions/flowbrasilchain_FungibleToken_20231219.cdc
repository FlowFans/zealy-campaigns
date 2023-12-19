import FungibleToken from 0xf233dcee88fe0abe
import brasil from 0x7bf07d719dcb8480

// Transação para configurar um cofre de token Brasil e linkar capacidades públicas
transaction {

    prepare(signer: AuthAccount) {
        // Verifica se o cofre Brasil já existe e, se não, cria um novo
        if signer.borrow<&brasil.Vault>(from: /storage/brasilVault) == nil {
            // Cria e salva um novo cofre Brasil no armazenamento do remetente
            let newVault <- brasil.createEmptyVault()
            signer.save(<-newVault, to: /storage/brasilVault)

            // Linka uma capacidade pública para receber tokens Brasil
            signer.link<&brasil.Vault{FungibleToken.Receiver}>(
                /public/brasilReceiver,
                target: /storage/brasilVault
            )

            // Linka uma capacidade pública para consultar o saldo do cofre Brasil
            signer.link<&brasil.Vault{FungibleToken.Balance}>(
                /public/brasilBalance,
                target: /storage/brasilVault
            )
        }
    }

    execute {
    }
}
