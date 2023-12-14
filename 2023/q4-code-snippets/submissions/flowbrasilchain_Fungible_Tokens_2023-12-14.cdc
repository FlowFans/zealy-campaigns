import ExampleToken from 0x6a56bcfb7129bf41

transaction {

    prepare(signer: AuthAccount) {

        // Verifica se o usuário já tem um Vault
        if signer.borrow<&ExampleToken.Vault>(from: /storage/ExampleTokenVault) == nil {

            // Cria um novo Vault vazio e salva no armazenamento
            let vault <- ExampleToken.createEmptyVault()
            signer.save(<-vault, to: /storage/ExampleTokenVault)

            // Cria uma referência pública para o Receiver do Vault
            signer.link<&ExampleToken.Vault{ExampleToken.Receiver}>(
                /public/ExampleTokenReceiver,
                target: /storage/ExampleTokenVault
            )

            log("Um novo Vault foi criado e configurado com sucesso.")
        } else {
            log("A conta ja possui um Vault configurado.")
        }
    }
}
