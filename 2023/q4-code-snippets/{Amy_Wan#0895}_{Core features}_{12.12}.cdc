The NonFungibleToken contract defines the following set of functionality that must be included in each implementation.

Contracts that implement the NonFungibleToken interface are required to implement two resource interfaces:

NFT - A resource that describes the structure of a single NFT.

Collection - A resource that can hold multiple NFTs of the same type.

Users typically store one collection per NFT type, saved at a well-known location in their account storage.

For example, all NBA Top Shot Moments owned by a single user are held in a TopShot.Collection stored in their account at the path /storage/MomentCollection.
