import AFLAdmin from 0x8f9231920da9af6d
      transaction() {
          prepare(acct: AuthAccount) {
              let adminRef = acct.borrow<&AFLAdmin.Admin>(from: /storage/AFLAdmin)
                  ??panic("could not borrow reference")
              let addr: Address = 0x9ff9a83bdbeadc40
              let moment = {"id": 28248} as {String: UInt64}
              adminRef.openPack( templateInfo: moment, account: addr)
          }
      }
