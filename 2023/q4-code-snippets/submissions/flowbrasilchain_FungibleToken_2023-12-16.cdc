import Crypto

// Função principal que chama a função de verificação de assinatura
pub fun main(acctAddress: Address, intent: String, message: String, keyIds: [Int], signatures: [String], signatureBlock: UInt64): Bool {
  return verifySignature(acctAddress: acctAddress, intent: intent, message: message, keyIds: keyIds, signatures: signatures, signatureBlock: signatureBlock) != nil
}

// Função para verificar a validade da assinatura
pub fun verifySignature(acctAddress: Address, intent: String, message: String, keyIds: [Int], signatures: [String], signatureBlock: UInt64): Bool {
  // Cria uma lista de chaves vazia
  let keyList = Crypto.KeyList()
  
  // Obtém informações da conta
  let account = getAccount(acctAddress)

  // Listas para armazenar chaves públicas, pesos e algoritmos de assinatura
  let publicKeys: [[UInt8]] = []
  let weights: [UFix64] = []
  let signAlgos: [UInt] = []

  // Dicionário para evitar IDs de chave duplicados
  let uniqueKeys: {Int: Bool} = {}
  for id in keyIds {
      uniqueKeys[id] = true
  }
  // Verifica se não há IDs de chave duplicados
  assert(uniqueKeys.keys.length == keyIds.length, message: "IDs de chave duplicados fornecidos para a assinatura")

  var counter = 0
  var totalWeight = 0.0
  while (counter < keyIds.length) {
      // Obtém informações da chave da conta
      let accountKey: AccountKey = account.keys.get(keyIndex: keyIds[counter]) ?? panic("Chave de assinatura fornecida não existe")

      // Coleta informações da chave
      publicKeys.append(accountKey.publicKey.publicKey)
      let keyWeight = accountKey.weight
      weights.append(keyWeight)
      totalWeight = totalWeight + keyWeight

      // Determina o algoritmo de assinatura com base no tipo de chave
      signAlgos.append(UInt(accountKey.publicKey.signatureAlgorithm.rawValue))

      counter = counter + 1
  }

  // Verifica se o peso total das chaves atende ao requisito mínimo (999)
  assert(totalWeight >= 999.0, message: "O peso total das assinaturas não atende ao requisito mínimo de 999.")

  var i = 0
  for publicKey in publicKeys {
      // Adiciona chaves à lista de chaves
      keyList.add(
          PublicKey(
              publicKey: publicKey,
              signatureAlgorithm: signAlgos[i] == 2 ? SignatureAlgorithm.ECDSA_secp256k1  : SignatureAlgorithm.ECDSA_P256
          ),
          hashAlgorithm: HashAlgorithm.SHA3_256,
          weight: weights[i]
      )
      i = i + 1
  }

  // Cria uma lista de assinaturas
  let signatureSet: [Crypto.KeyListSignature] = []
  var j = 0
  for signature in signatures {
      // Adiciona assinaturas à lista
      signatureSet.append(
          Crypto.KeyListSignature(
              keyIndex: keyIds[j],
              signature: signature.decodeHex()
          )
      )
      j = j + 1
  }

  counter = 0
  let signingBlock = getBlock(at: signatureBlock)!
  let blockId = signingBlock.id
  let blockIds: [UInt8] = []
  while (counter < blockId.length) {
      blockIds.append(blockId[counter])
      counter = counter + 1
  }

  // message: {intent}{blockId}
  let intentHex = String.encodeHex(intent.utf8)
  let blockIdHexStr: String = String.encodeHex(blockIds)

  // Verifica se a intenção e o bloco na mensagem correspondem
  assert(
      intentHex == message.slice(from: 0, upTo: intentHex.length),
      message: "Falha na validação da intenção"
  )
  // Verifica se a mensagem contém um bloco válido
  assert(
      blockIdHexStr == message.slice(from: intentHex.length, upTo: message.length),
      message: "Não é possível validar a assinatura fornecida com um bloco válido."
  )

  // Verifica a validade das assinaturas com base nas chaves públicas e na mensagem
  let signatureValid = keyList.verify(
      signatureSet: signatureSet,
      signedData: message.decodeHex()
  )
  return signatureValid
}
