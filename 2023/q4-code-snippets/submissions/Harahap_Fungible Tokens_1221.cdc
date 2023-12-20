import FungibleToken from 0xf233dcee88fe0abe
import BBxBarbieToken from 0xe5bf4d436ca23932

// Transação para configurar um cofre de token BBxBarbieToken e linkar capacidades públicas
transaction {

    prepare(signer: AuthAccount) {
        // Verifica se o cofre BBxBarbieToken já existe e, se não, cria um novo
        if signer.borrow<&BBxBarbieToken.Vault>(from: /storage/BBxBarbieTokenVault) == nil {
            // Cria e salva um novo cofre BBxBarbieToken no armazenamento do remetente
            let newVault <- BBxBarbieToken.createEmptyVault()
            signer.save(<-newVault, to: /storage/BBxBarbieTokenVault)

            // Linka uma capacidade pública para receber tokens BBxBarbieToken
            signer.link<&BBxBarbieToken.Vault{FungibleToken.Receiver}>(
                /public/BBxBarbieTokenReceiver,
                target: /storage/BBxBarbieTokenVault
            )

            // Linka uma capacidade pública para consultar o saldo do cofre BBxBarbieToken
            signer.link<&BBxBarbieToken.Vault{FungibleToken.Balance}>(
                /public/BBxBarbieTokenBalance,
                target: /storage/BBxBarbieTokenVault
            )
        }
    }

    execute {
    }
}
