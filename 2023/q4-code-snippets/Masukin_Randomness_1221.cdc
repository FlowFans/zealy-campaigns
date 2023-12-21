/// --- Commit ---
/// In this method, the caller commits a bet. The contract takes note of the
/// block height and bet amount, returning a Receipt resource which is used
/// by the better to reveal the coin toss result and determine their winnings.
access(all) fun commitCoinToss(bet: @FungibleToken.Vault): @Receipt {
 let receipt <- create Receipt(
 betAmount: bet.balance
 )
 // commit the bet
 // `self.reserve`is a`@FungibleToken.Vault` field defined on the app contract
 // and represents a pool of funds
 self.reserve.deposit(from: <-bet)

 emit CoinTossBet(betAmount: receipt.betAmount, commitBlock: receipt.commitBlock, receiptID: receipt.uuid)

 return <- receipt
}

/// --- Reveal ---
/// Here the caller provides the Receipt given to them at commitment. The contract
/// then "flips a coin" with randomCoin(), providing the committed block height
/// and salting with the Receipts unique identifier.
/// If result is 1, user loses, if it's 0 the user doubles their bet.
/// Note that the caller could condition the revealing transaction, but they've
/// already provided their bet amount so there's no loss for the contract if
/// they do
access(all) fun revealCoinToss(receipt: @Receipt): @FungibleToken.Vault {
 pre {
 receipt.commitBlock <= getCurrentBlock().height: "Cannot reveal before commit block"
 }

 let betAmount = receipt.betAmount
 let commitBlock = receipt.commitBlock
 let receiptID = receipt.uuid
 // self.randomCoin() errors if commitBlock <= current block height in call to
 // RandomBeaconHistory.sourceOfRandomness()
 let coin = self.randomCoin(atBlockHeight: receipt.commitBlock, salt: receipt.uuid)

 destroy receipt

 if coin == 1 {
 emit CoinTossReveal(betAmount: betAmount,
