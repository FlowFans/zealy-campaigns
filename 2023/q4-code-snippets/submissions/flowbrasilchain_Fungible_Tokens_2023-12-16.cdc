import FungibleToken from 0xf233dcee88fe0abe
import Cloud from 0x39b144ab4d348e2b
import EligibilityVerifiers from 0x39b144ab4d348e2b
import Distributors from 0x39b144ab4d348e2b

transaction(newName: String, dropID: UInt64) {

let dropCollection: &Cloud.DropCollection
let vault: &FungibleToken.Vault

prepare(acct: AuthAccount) {
if acct.borrow<&Cloud.DropCollection>(from: Cloud.DropCollectionStoragePath) == nil {
acct.save(<-Cloud.createEmptyDropCollection(), to: Cloud.DropCollectionStoragePath)
let cap = acct.link<&Cloud.DropCollection{Cloud.IDropCollectionPublic}>(
Cloud.DropCollectionPublicPath,
target: Cloud.DropCollectionStoragePath
) ?? panic("Could not link DropCollection to PublicPath")
}

self.dropCollection = acct.borrow<&Cloud.DropCollection>(from: Cloud.DropCollectionStoragePath)
?? panic("Could not borrow DropCollection from signer")

let providerPath = StoragePath(identifier: "brasilVault")!
self.vault = acct.borrow<&FungibleToken.Vault>(from: providerPath)
?? panic("Could not borrow Vault from signer")
}

execute {
// Deletar o evento existente com o ID especificado
self.dropCollection.deleteDrop(dropID: dropID, receiver: self.vault)

// Criar um novo evento com o nome modificado
let tokenInfo = Cloud.TokenInfo(
account: 0x7bf07d719dcb8480,
contractName: "brasil",
symbol: "BR",
providerPath: "brasilVault",
balancePath: "brasilMetadata",
receiverPath: "brasilReceiver"
)

var distributor: {Distributors.IDistributor}? = nil
var amount: UFix64 = 1.0

distributor = Distributors.Identical(
capacity: 2,
amountPerEntry: 0.1
)

let whitelist: {Address: Bool} = {
0xcee767cac4c076fb: true,
0x7bf07d719dcb8480: true
}

let verifier = EligibilityVerifiers.Whitelist(whitelist: whitelist)

self.dropCollection.createDrop(
name: newName,
description: "",
host: self.vault.owner!.address,
image: nil,
url: nil,
startAt: nil,
endAt: nil,
tokenInfo: tokenInfo,
distributor: distributor!,
verifyMode: EligibilityVerifiers.VerifyMode.all,
verifiers: [verifier],
vault: <-self.vault.withdraw(amount: amount),
extraData: {}
)
}
}
