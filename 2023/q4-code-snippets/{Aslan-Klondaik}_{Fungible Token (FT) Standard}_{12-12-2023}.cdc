1- Getting metadata for the token smart contract via the fields of the contract:

pub var totalSupply: UFix64
The only required field of the contract. It would be incremented when new tokens are minted and decremented when they are destroyed.
Event that gets emitted when the contract is initialized
pub event TokensInitialized(initialSupply: UFix64)
2- Retrieving the token fields of a Vault in an account that owns tokens.

Balance interface
pub var balance: UFix64
The only required field of the Vault type
3- Withdrawing a specific amount of tokens amount using the withdraw function of the owner's Vault

Provider interface
pub fun withdraw(amount: UFix64): @FungibleToken.Vault
Conditions
the returned Vault's balance must equal the amount withdrawn
The amount withdrawn must be less than or equal to the balance
The resulting balance must equal the initial balance - amount
Users can give other accounts a reference to their Vault cast as a Provider to allow them to withdraw and send tokens for them. A contract can define any custom logic to govern the amount of tokens that can be withdrawn at a time with a Provider. This can mimic the approve, transferFrom functionality of ERC20.
withdraw event
Indicates how much was withdrawn and from what account the Vault is stored in. If the Vault is not in account storage when the event is emitted, from will be nil.
pub event TokensWithdrawn(amount: UFix64, from: Address?)
4 - Depositing a specific amount of tokens from using the deposit function of the recipient's Vault

Receiver interface

pub fun deposit(from: @FungibleToken.Vault)
Conditions
from balance must be non-zero
The resulting balance must be equal to the initial balance + the balance of from
deposit event

Indicates how much was deposited and to what account the Vault is stored in. If the Vault is not in account storage when the event is emitted, to will be nil.
pub event TokensDeposited(amount: UFix64, to: Address?)
Users could create custom Receivers to trigger special code when transfers to them happen, like forwarding the tokens to another account, splitting them up, and much more.

It is important that if you are making your own implementation of the fungible token interface that you cast the input to deposit as the type of your token. let vault <- from as! @ExampleToken.Vault The interface specifies the argument as @FungibleToken.Vault, any resource that satisfies this can be sent to the deposit function. The interface checks that the concrete types match, but you'll still need to cast the Vault before storing it.

5 - Creating an empty Vault resource

pub fun createEmptyVault(): @FungibleToken.Vault
Defined in the contract To create an empty Vault, the caller calls the function in the contract and stores the Vault in their storage.
Conditions:
the balance of the returned Vault must be 0
6 - Destroying a Vault

If a Vault is explicitly destroyed using Cadence's destroy keyword, the balance of the destroyed vault must be subtracted from the total supply.

7 - Standard for Token Metadata

not sure what this should be yet
Could be a dictionary, could be an IPFS hash, could be json, etc.
need suggestions!
Comparison to Similar Standards in Ethereum
This spec covers much of the same ground that a spec like ERC-20 covers, but without most of the downsides.

Tokens cannot be sent to accounts or contracts that don't have owners or don't understand how to use them, because an account has to have a Vault in its storage to receive tokens. No safetransfer is needed.
If the recipient is a contract that has a stored Vault, the tokens can just be deposited to that Vault without having to do a clunky approve, transferFrom
Events are defined in the contract for withdrawing and depositing, so a recipient will always be notified that someone has sent them tokens with the deposit event.
The approve, transferFrom pattern is not included, so double spends are not permitted
Transfers can trigger actions because users can define custom Receivers to execute certain code when a token is sent.
Cadence integer types protect against overflow and underflow, so a SafeMath-equivalent library is not needed.
FT Metadata
FT Metadata is represented in a flexible and modular way using both the standard proposed in FLIP-0636 and the standard proposed in FLIP-1087.

When writing an NFT contract, you should implement the MetadataViews.Resolver interface, which allows your Vault resource to implement one or more metadata types called views.

Views do not specify or require how to store your metadata, they only specify the format to query and return them, so projects can still be flexible with how they store their data.

Fungible token Metadata Views
The Example Token contract defines three new views that can used to communicate any fungible token information:

FTView A view that wraps the two other views that actually contain the data.
FTDisplay The view that contains all the information that will be needed by other dApps to display the fungible token: name, symbol, description, external URL, logos and links to social media.
FTVaultData The view that can be used by other dApps to interact programmatically with the fungible token, providing the information about the public and private paths used by default by the token, the public and private linked types for exposing capabilities and the function for creating new empty vaults. You can use this view to setup an account using the vault stored in other account without the need of importing the actual token contract.
