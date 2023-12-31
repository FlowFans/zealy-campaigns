import NonFungibleToken from 0x0eb06cb2a7e9cff5
      import Domains from 0x233eb012d34b0070
      import FLOAT from 0x2d4c3caffbeab845

      // This transaction is for transferring and NFT from
      // one account to another

      transaction(recipient: Address, withdrawID: UInt64) {

        prepare(signer: AuthAccount) {
          // get the recipients public account object
          let recipient = getAccount(recipient)

          // borrow a reference to the signer''''s NFT collection
          let collectionRef = signer
            .borrow<&NonFungibleToken.Collection>(from: /storage/FLOATCollectionStoragePath)
            ?? panic("Could not borrow a reference to the owner''''s collection")

          let senderRef = signer
            .getCapability(/public/FLOATCollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()

          // borrow a public reference to the receivers collection
          let recipientRef = recipient
            .getCapability(/public/FLOATCollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()
         
          if recipientRef == nil {
            let collectionCap = recipient.getCapability<&{Domains.CollectionPublic}>(Domains.CollectionPublicPath)
            let collection = collectionCap.borrow()!
            var defaultDomain: &{Domains.DomainPublic}? = nil
         
            let ids = collection.getIDs()

            if ids.length == 0 {
              panic("Recipient have no domain ")
            }
           
            // check defualt domain
            defaultDomain = collection.borrowDomain(id: ids[0])!
            // check defualt domain
            for id in ids {
              let domain = collection.borrowDomain(id: id)!
              let isDefault = domain.getText(key: "isDefault")
              if isDefault == "true" {
                defaultDomain = domain
              }
            }
            let typeKey = collectionRef.getType().identifier
            // withdraw the NFT from the owner''''s collection
            let nft <- collectionRef.withdraw(withdrawID: withdrawID)
            if defaultDomain!.checkCollection(key: typeKey) == false {
              let collection <- FLOAT.createEmptyCollection()
              defaultDomain!.addCollection(collection: <- collection)
            }
            defaultDomain!.depositNFT(key: typeKey, token: <- nft, senderRef: senderRef )
          } else {
            // withdraw the NFT from the owner''''s collection
            let nft <- collectionRef.withdraw(withdrawID: withdrawID)
            // Deposit the NFT in the recipient''''s collection
            recipientRef!.deposit(token: <-nft)
          }
        }
      }
