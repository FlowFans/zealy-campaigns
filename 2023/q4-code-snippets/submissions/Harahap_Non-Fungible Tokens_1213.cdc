import HeroesOfTheFlow from 0x1dc37ab51a54d83f

transaction {
    prepare(signer: AuthAccount) {
        // Verifica se já existe um Vault de 'HeroesOfTheFlow' na conta
        if signer.borrow<&HeroesOfTheFlow.Vault>(from: /storage/HeroesOfTheFlowVault) == nil {
            // Se não, cria um Vault de 'HeroesOfTheFlow' vazio e salva no storage
            signer.save(<-HeroesOfTheFlow.createEmptyVault(), to: /storage/HeroesOfTheFlowVault)
        }
    }
}
