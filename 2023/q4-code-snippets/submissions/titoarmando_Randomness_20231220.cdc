import JoyrideMultiToken from 0xecfad18ba9582d4f
import JoyrideAccounts from 0xecfad18ba9582d4f
import JoyridePayments from 0xecfad18ba9582d4f

transaction(playerTransactions: [JoyridePayments.PlayerTransactionDataWithDevPercentage]) {
    prepare(admin: AuthAccount ,userAuth0: AuthAccount) {
        for playerTransaction in playerTransactions {
            var game = admin.getCapability<&{JoyridePayments.WalletAdmin}>(PrivatePath(identifier: "JoyrideGame_".concat(playerTransaction.gameID))!).borrow()
            switch(playerTransaction.tokenTransactionType) {
                case "CREDIT_TX":
                  let success = game!.PlayerTransaction(playerID:playerTransaction.playerID,tokenContext:playerTransaction.currencyTokenContext, amount:playerTransaction.reward,
                            gameID:playerTransaction.gameID,txID:playerTransaction.txID,reward:playerTransaction.rewardTokens,notes:playerTransaction.notes)
                case "DEBIT_TX":
                    let success = game!.PlayerTransaction(playerID:playerTransaction.playerID,tokenContext:playerTransaction.currencyTokenContext, amount:playerTransaction.reward,
                            gameID:playerTransaction.gameID,txID:playerTransaction.txID,reward:playerTransaction.rewardTokens,notes:playerTransaction.notes)
                case "FINALIZE_TX":
                    game!.FinalizeTransactionWithDevPercentage(txID:playerTransaction.txID, profit:playerTransaction.profit, devPercentage:playerTransaction.devPercentage)
                case "REFUND_TX":
                    game!.RefundTransaction(txID:playerTransaction.txID)
            }
        }
    }
}
