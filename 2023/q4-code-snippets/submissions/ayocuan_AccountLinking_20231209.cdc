class UserWallet:
    def __init__(self, user_id, blockchain_account):
        self.user_id = user_id
        self.blockchain_account = blockchain_account
        self.hybrid_custody_enabled = False

    def link_external_account(self, external_account):
        # Implementing account linking logic
        # This could involve user authentication and validation
        # Assume the external account is validated successfully
        self.hybrid_custody_enabled = True

    def transfer_assets(self, recipient, amount):
        if self.hybrid_custody_enabled:
            # Implementing hybrid custody logic
            # Transfer assets securely between linked accounts
            transaction_result = blockchain_transfer(self.blockchain_account, recipient.blockchain_account, amount)
            return transaction_result
        else:
            return "Hybrid custody not enabled. Please link an external account first."

# Example usage:
user1 = UserWallet(user_id=1, blockchain_account="user1_blockchain_account")
user2 = UserWallet(user_id=2, blockchain_account="user2_blockchain_account")

# Linking an external account for user1
user1.link_external_account("user1_external_account")

# Performing a transfer between linked accounts
transfer_result = user1.transfer_assets(user2, 10)

print(transfer_result)
