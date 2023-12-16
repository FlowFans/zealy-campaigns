#allowAccountLinking
transaction(linkPathSuffix: String) {
 prepare(account: AuthAccount) {
  let linkPath = PrivatePath(identifier: linkPathSuffix)
  if !account.getCapability<&AuthAccount>(linkPath).check() {
   account.unlink(linkpath)
   account.linkAccount(linkPath)
  }
 }
}
