import brasil from 0x7bf07d719dcb8480

transaction {
    prepare(signer: AuthAccount) {
        // Verifica se já existe um Vault de 'brasil' na conta
        if signer.borrow<&brasil.Vault>(from: /storage/brasilVault) == nil {
            // Se não, cria um Vault de 'brasil' vazio e salva no storage
            signer.save(<-brasil.createEmptyVault(), to: /storage/brasilVault)
        }
    }
}
