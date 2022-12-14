# Royalty Enforced NFT

The idea here is to create the most simple NFT standard that enforces creator royalties. This is a proof of concept and very open to feedback. I don't believe this is an entirely new idea, but it was fun to come up with an example implementation.

<img width="700" alt="Drawing-22 sketchpad" src="https://user-images.githubusercontent.com/16373521/196536748-0bb9fdf6-c868-4123-866d-d4efa3da9990.png">

## Motivation

NFT royalties are a hot topic as of late. Marketplaces such as Magic Eden and DyDx have implemented "optional royalties", and other protocols such as sudo swap circumvent royalties alltogether.

This can be harmful to artists or projects who require royalties to continue contributing to their project / create value for collectors.

While royalties may not be a sound business model for many projects, I do believe artists should be able to enforce royalties originally described in their contract. With current token standards, even if they implement [EIP-2981 royalty standerd](https://eips.ethereum.org/EIPS/eip-2981), royalties are merely a suggestion to marketplaces. As marketplaces compete for traders, I believe the royalty race will eventually go to zero.

The community has rightfully pointed out some of the hypocracy of marketplaces too. Marketplaces will often make creator royalties optional, but their own marketplace fees are still required. This is counter to the web3 ideals of supporting artists, eliminating rent seekers who extract more value than they create, and relying on code as law.

## Solution

Marketplaces will always be able to circumvent creator royalties <u>**as long as the tokens allow for non-financial transfers**</u>.

If you have the ability to gift or airdrop someone a token (a non-financial transfer), marketplaces can have the original owner "gift" the token to a third party contract (e.g. the marketplace contract), then handle the finances separately before "gifting" it again to the end buyer. With this flow, royalties are never enforced in the original contract.

The solution we propose makes it impossible to trade NFTs without financial transfer. The ONLY way to trade an NFT in `royalty-enforced-nft` is by listing your token directly through the token contract for a price.

Once a token is listed, anyone may acquire the token for the listed price + the royalties specified by the contract creator.

If you attempt to list a token for a small price or gift it, there is an arbitrage opportunity as anyone can potentially claim the token at a discount. As such, sellers are incentivised to list their token at a fair price such that royalties will be enforced.

## Trade Offs

It is important to recognize that this type of standard would not be right for (likely most) NFT projects. Enforcing only financial trades is a pretty restrictive / opinionated flow which limits the interoperability of the token in some ways.

- e.g. you cannot gift your token or airdrop it to another wallet
- You cannot easily transfer the token between hot / cold wallets without buying it from yourself (and paying royalties)
- Traditional marketplaces will never adopt this type of thing because it completely destroys their business model which requires financial transactions going through their third party contracts.
- As a result, royalty enforced NFTs might not get much of the great features that marketplaces provide. e.g. auctions / collection offers etc...
  - this kind of thing would be up to the token creator to implement on their original contract
- Generally, this is a much more restrictive standard and should be used accordingly
- Other critiques? Are there ways to circumvent this? Very open to feedback.

All this being said, I still think royalty-enforced-nft is a valid option for certain artists where royalties are a priority, and a meaningful push back to empower creators.

## Disclaimer on the Code

- This code is not tested / audited as of yet. Usea at your own discretion
- This is meant to be an example, and is incomplete. E.G. does not implement withdraws / max supply / token mint price etc...

## Other Ideas / Direction

- The listing flow could fairly easily support ERC20 tokens as well, not just native ether
- Could implement this as a one way wrapper to accept existing immutable ERC721s and issue royalty enforced wrapper tokens
- Could maintain balances for pull payments rather than buyer push payments
- The contract might also include "marketplace bips" as a fee to incentivise marketplaces to support specific collections that is **opt in** on a contract level.
  - e.g. creators could CHOOSE to incentivise marketplaces
