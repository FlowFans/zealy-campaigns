To use the Flow Token contract as is, you need to follow these steps:

If you are using the Playground, you need to deploy the FungibleToken definition to account 1 yourself and import it in ExampleToken. It is a predeployed interface in the emulator, testnet, and mainnet and you can import definition from those accounts:
0xee82856bf20e2aa6 on emulator
0x9a0766d93b6608b7 on testnet
0xf233dcee88fe0abe on mainnet
Deploy the ExampleToken definition
You can use the get_balance.cdc or get_supply.cdc scripts to read the balance of a user's Vault or the total supply of all tokens, respectively.
Use the setupAccount.cdc on any account to set up the account to be able to use FlowTokens.
Use the transfer_tokens.cdc transaction file to send tokens from one user with a Vault in their account storage to another user with a Vault in their account storage.
Use the mint_tokens.cdc transaction with the admin account to mint new tokens.
Use the burn_tokens.cdc transaction with the admin account to burn tokens.
Use the create_minter.cdc transaction to create a new MintandBurn resource and store it
