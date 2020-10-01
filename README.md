## Blockchain Repository for “Currency Stability Using Blockchain Technology”
### Bryan Routledge and Ariel Zetlin-Jones
### Tepper School of Business
### Carnegie Mellon University                  
### October 2, 2020                                
### Email: azj@andrew.cmu.edu

**Acknowledgements:** Routledge and Zetlin-Jones are grateful to Michael
McCarthy (Heinz College, CMU) for sharing his materials on Ethereum Smart 
Contract deployment and interaction.

**Summary:** This Github repository contains instructions to set up an 
Ethereum development environment (using Truffle and Ganache), to deploy 
one smart contract to an Ethereum test blockchain, and to interact with 
that contract via Remix and a web-based interface. The smart contract
is written in the Solidity programming language.

## Part 1. Installations

1) Install git.
   See https://git-scm.com/downloads
2) Download and install node.js and npm.
   The node package manager (npm) is included with the download of
   node.js. See https://nodejs.org/en/download/
3) Download and install truffle.
   See: https://truffleframework.com/docs/truffle/getting-started/installation
   npm install -g truffle
4) Download and install Ganache.
   See: https://truffleframework.com/ganache
5) If you want to use Atom as your editor (recommended) , download and install atom.
   See: https://atom.io
6) If you are using Atom, you may want to download and install
   language-solidity for Atom.
   See: https://atom.io/packages/language-solidity
7) If you are using Atom, you may want to download and install atom-solidity-linter
   for Atom.
   See: https://atom.io/packages/atom-solidity-linter

## Part 2  (Deploying the Contract)

1) Run ganache, choose the quick start option and leave it running.

2) We recommend using the Remix IDE to compile Solidity source code. We will also

   use Remix to deploy byte code to Ganache and interact with the contract.

   Remix runs in your browser. You do not need to install it.


   Visit https://remix.ethereum.org/

3) In Remix, choose Solidity and create a new file named “CryptoPeg.sol".

4) [Paste this code to CryptoPeg.sol](../../blob/master/CryptoPeg.sol)


5) In Remix, click on "Compile CryptoPeg.sol" on the left sidebar.  (Once compilation
   is complete, you may view the ABI. The ABI or Application Binary Interface is a
   machine readable description of the public features of the contract. You will find
   this ABI already included in the html “wallets” our fictional users will use to
   interact with the deployed smart contract.
   You might also take a peek at the bytecode. This is the code that we will deploy to Ganache. It is the compiled Solidity code.

6) Click the "Deploy and run transactions" icon on the left sidebar of Remix. The default environment is set to "Javascript VM". The CryptoPeg.sol contract can be tested in Remix using the Javascript VM environment. However, the Javascript VM environment is only used for local testing.  In this lab we will be using a Web3 Provider that allows us to connect to a running node. In this case, we want to connect to Ganache.

7) In Remix, visit the Environment selection box and choose "Web3 Provider". You will be prompted with an "External Node Request" box. Your Web3 Provider Endpoint is http://localhost:7545. See the Ganache user interface and verify the port (7545) is correct. A Web3 Provider knows how to talk to a running node.

9) Our Smart Contract allows the user to pre-determine some initial settings (Quantity of Tokens, Token Name and Ticker Symbol) upon deployment. Click on the drop-down arrow to the right of the Deploy button to view these setting options. To mimic the video demo, enter “30” for the initial supply, “cryptopepgcoin” for Tokenname and “CPPC” for TokenSymbol. Then click “transact.” Note how the first account in Ganache has spent a little ETH. It costs money to deploy a contract. Notice too, on Ganache, the Transactions tab shows a contract creation transaction. By clicking on the transaction itself, you can see the hash of the transaction, the bytecode of the contract, and other details regarding the costs of things.

## Part 3  (Interacting with the Contract)

1) We will use truffle to allow for web-based interaction with the smart contract. Create a new project directory on your desktop named CryptoPeg and cd into it using a terminal.
2) Execute the following commands:

```
   truffle init
   npm init      take the suggested defaults
   npm install dotenv truffle-wallet-provider ethereumjs-wallet web3
```

3) Examine the directory structure:

* **contracts** holds solidity source code
  * Migrations.sol is a deployment contract
* **migrations** holds javascript code for efficient redeployments
  * 1_initial_migrations.js
  * This first migration deploys the Migrations.sol contract.
* **test**
  * This directory is for writing tests in Javascript.
It typically uses the mocha framework and Chai Assertions library.
In more complex deployments, this directory structure will mirror
the directory structure required by the application.
* **truffle-config.js**

  * This Javascript file contains configuration parameters for this truffle project.

4) Within the directory named CryptoPeg, create a file named index_bob.html and [copy the code found here.](./html/index_bob.html)

5) Within the directory named CryptoPeg, create a file named index_charlie.html and [copy the code found here.](./html/index_charlie.html)

6) Within the directory named CryptoPeg, create a file named index_donna.html and [copy the code found here.](./html/index_donna.html)

7) Within the directory named Lab2PartA, create a file named index.css and [copy the code found here.](./html/index.css)

8) Find the deployed contract address (from Remix or from Ganache) and enter this in line 675 of each of the previous 3 HTML files (the ValueContract.at('ENTER HERE')). Open the files. You should be able to check the ETH balance of each user and see that it corresponds to the Ganache address balances of Address Indexes 1, 2, and 3.

## Part 4  (Simulating the CryptoPeg Economy)

In what follows, we refer to Alice as the first Ganache account (Account 0), Bob as the second (Account 1), Charlie as the third (Account 2), and Donna as the fourth (Account 3).

1) Our solidity code initially allows Alice full control of the tokens. To initiate the simulation, Alice will set prices so that Traders must send .9 ETH to receive 1 CPC but for each CPC they send to the contract, they receive 0 ETH. (This prevents them from redeeming their coins early.) In Remix, under "Deployed Contracts", “CryptoPeg” will be listed. Expand that node and expand the “setPrices” node. Enter a newSellPrice of “0” and a newBuyPrice of “900000000000000000”. Click on “Transact”.

2) For traders to buy tokens from the contract, the contract must own tokens, so Alice will transfer her 30 CPC Tokens to the contract. Expand the “transfer” node, enter the contract address in the “_to” field and enter “30” in the “_value” field. Click on “Transact.”

3) Using the web-based UI for Bob, Charlie, and Donna, have each trader acquire 10 CPC tokens. On each page, have them enter “9” in the box “Enter the number of ETH you want to Sell.” Click the “Push to Purchase CPC Coins”. Verify the transaction processed (in Ganache) and that each users’s balance of ETH and CPC coin have updated.

4) Now Alice is ready to initialize the exchange rate protocol. First, Alice chooses the order traders will be sequenced. In Remix, expand the “setTraders” node. Choose an order for the traders by entering Bob, Charlie and Donna’s addresses (accessible from Ganache or Remix) in the positions of newtrader1, newtrader2, and newtrader3. (For the rest of this demo, we assume Bob is trader 1, Charlie is trader 2, and Donna is trader 3.) Click on “Transact”.

5) Alice freezes the accounts of Bob, Charlie and Donna by clicking on “freezeall”. She then starts the protocol by clicking on “runpeg”. Observing the method “runpeg” in the solidity code reveals that this command updates the sell price to 1 ETH per CPC token, unfreezes trader 1’s account, and then transfers ownership of the contract to the contract itself. At this point, should Alice send any commands to mint or burn tokens, or to change the prices, the contract will reject her transaction as she no longer has ownership status.

6) Since Bob is trader 1, only his account is unfrozen. He may redeem 10 tokens (or not by redeeming 0) tokens. Once he sends a purchase request (again, of 10 or 0 tokens), the contract will automatically freeze his account and update the redemption price of CPC tokens. You can verify this by checking his account status as well as Charlie’s (that should now be unfrozen). Repeat the above steps for Charlie and Donna.
