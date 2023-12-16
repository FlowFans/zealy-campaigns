import BasicToken from 0x3e2ffae3d9e03ece

transaction {

    prepare(signer: AuthAccount) {

        // Verifica se o usuário já tem um Vault
        if signer.borrow<&BasicToken.Vault>(from: /storage/BasicTokenVault) == nil {

            // Cria um novo Vault vazio e salva no armazenamento
            let vault <- BasicToken.createEmptyVault()
            signer.save(<-vault, to: /storage/BasicTokenVault)

            // Cria uma referência pública para o Receiver do Vault
            signer.link<&BasicToken.Vault{BasicToken.Receiver}>(
                /publicBasicTokenReceiver,
                target: /storage/BasicTokenVault
            )

            log("Um novo Vault foi criado e configurado com sucesso.")
        } else {
            log("A conta ja possui um Vault configurado.")
        }
    }
}
