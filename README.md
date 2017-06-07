# Ethereum Oracles smart contract
Ethereum Oracles smart contract to manage notaries in Oracles PoA

## Common Oracles contract features checklist
| № | Description                                             | Status |
|---|:-----------------------------------------------------|:--------------------------:|
| 1 | Initial key is generated only by contract owner     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 2 | Initial key generation isn't possible after it's generation limit (12) is reached     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 3 | Initial key has no authority to be a notary     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 4 | Initial key is invalidated immediately after mining/payout/voting keys are created     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 5 | Mining/payout/voting keys generation is possible only with valid initial key     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 6 | Mining/payout/voting keys can be changed by owner anytime    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 7 | Ballot management is accessed only with valid voting key    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 8 | Ballot creation isn't possible, if limit of licenses distribution (52) is reached    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 9 | Ballot creation to add notary isn't possible, if notary is already added to PoA    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 10 | Ballot creation to add/remove notary isn't possible, if notary was removed from PoA before    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 11 | Voting is accessed only with valid voting key    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 12 | Voter is able to vote for the same ballot only once   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 13 | Voting is prohibited after ballot's expiration    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 14 | Ballot is successfully finished, if total amount of voters >= 3    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 15 | If ballot is successfully finished, removing or adding of notary is started only if amount of votes for > amount of votes against   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |

## Known Ethereum contracts attack vectors checklist

| № | Attack vector                  | Description                                                        | Status |
|---|:-----------------------------------------------------|:-----------------------------------------------------|:--------------------------:|
| 1 | [Race Conditions](https://github.com/ConsenSys/smart-contract-best-practices#race-conditions)     | The order of transactions themselves (within a block) is easily subject to manipulation | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 1.a | [Reentrancy](https://github.com/ConsenSys/smart-contract-best-practices#reentrancy)     | Functions can be called repeatedly, before the first invocation of the function was finished | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 1.b | [Cross-function Race Conditions](https://github.com/ConsenSys/smart-contract-best-practices#cross-function-race-conditions)     | A similar attack using two different functions that share the same state | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 1.c | [Pitfalls in Race Condition Solutions](https://github.com/ConsenSys/smart-contract-best-practices#cross-function-race-conditions)     | Avoiding of calling functions which call external functions | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 2 | [Timestamp Dependence](https://github.com/ConsenSys/smart-contract-best-practices#timestamp-dependence)     | Timestamp of the block can be manipulated by the miner | |
| 3 | [Integer Overflow and Underflow](https://github.com/ConsenSys/smart-contract-best-practices#integer-overflow-and-underflow)     | Usage of unlimited increments can cause such issue  | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 4 | [DoS with (Unexpected) Throw](https://github.com/ConsenSys/smart-contract-best-practices#dos-with-unexpected-throw)     | Unexpected throw is reached with some contract method for any user, because of malicious user called it before with bad parameters | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 5 | [DoS with Block Gas Limit](https://github.com/ConsenSys/smart-contract-best-practices#dos-with-block-gas-limit)     |  Block gas limit can be reached, for example, with looping through an array with unknown size and sending `send()` in a single transaction. Sending should be divided to multiple transactions| ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |

## Compiling of Oracles contract
Install [dapp cli](http://dapp.readthedocs.io/en/latest/installation.html#installing-dapp)

1) `git clone https://github.com/oraclesorg/oracles-contract` // clone repository

2) `cd oracles-contract/` // move to folder with project

3) `git submodule update --init --recursive` // get submodules data

4) `dapp build` // compiling of contracts to `./out`

Expected result: 

`./out/Oracles.bin` - bytecode of Oracles contract

`./out/Oracles.abi` - binary interface of Oracles contract


## Oracles contract definition
<div id="react-mount">
	<div class="ui container" data-reactid="10">
		<div class="ui grid">
			<div class="wide wide wide twelve twelve column computer mobile sixteen stretched tablet">
				<div class="contract">
					<div class="ui divider hidden" style="clear:both"></div>
					<div class="methods">
						<div class="ui segment">
							<div class="ui label ribbon right">
								function
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>addBallot</code> <code class="signature">54453c32</code></h3>
							<h4></h4>
							<p>Adds new Ballot</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="5" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>1</td>
									<td>address</td>
									<td><code>miningKey</code></td>
									<td>
										<div>
											<p>Mining key of notary which is proposed to add or remove</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>2</td>
									<td>bool</td>
									<td><code>addAction</code></td>
									<td>
										<div>
											<p>Flag: adding is true, removing is false</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>3</td>
									<td>string</td>
									<td><code>memo</code></td>
									<td>
										<div>
											<p>Ballot's memo</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>addInitialKey</code> <code class="signature">aff63d5e</code></h3>
							<h4></h4>
							<p>Adds initial key</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>key</code></td>
									<td>
										<div>
											<p>Initial key</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>addValidator</code> <code class="signature">0aeee835</code></h3>
							<h4></h4>
							<p>Adds new notary</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="7" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>miningKey</code></td>
									<td>
										<div>
											<p>Notary's mining key</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>1</td>
									<td>uint256</td>
									<td><code>zip</code></td>
									<td>
										<div>
											<p>Notary's zip code</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>2</td>
									<td>uint256</td>
									<td><code>licenseID</code></td>
									<td>
										<div>
											<p>Notary's license ID</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>3</td>
									<td>uint256</td>
									<td><code>licenseExpiredAt</code></td>
									<td>
										<div>
											<p>Notary's expiration date</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>4</td>
									<td>string</td>
									<td><code>fullName</code></td>
									<td>
										<div>
											<p>Notary's full name</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>5</td>
									<td>string</td>
									<td><code>streetName</code></td>
									<td>
										<div>
											<p>Notary's address</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>6</td>
									<td>string</td>
									<td><code>state</code></td>
									<td>
										<div>
											<p>Notary's US state full name</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>ballotCreatedAt</code> <code class="signature">b045d117</code></h3>
							<h4></h4>
							<p>Gets ballot's creation time</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's creation time</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>ballotIsActive</code> <code class="signature">75f358cc</code></h3>
							<h4></h4>
							<p>Checks, if ballot is active</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's activity: active or not</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>ballotIsVoted</code> <code class="signature">6f2dc1c1</code></h3>
							<h4></h4>
							<p>Checks, if ballot is already voted by signer of current transaction</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot is already voted by signer of current transaction: yes or no</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>ballots</code> <code class="signature">5c632b38</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>ballotsMapping</code> <code class="signature">32d21d00</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="10" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>owner</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>1</td>
									<td>address</td>
									<td><code>miningKey</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>2</td>
									<td>string</td>
									<td><code>memo</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>3</td>
									<td>uint256</td>
									<td><code>createdAt</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>4</td>
									<td>uint256</td>
									<td><code>votingStart</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>5</td>
									<td>uint256</td>
									<td><code>votingDeadline</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>6</td>
									<td>int256</td>
									<td><code>votesAmmount</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>7</td>
									<td>int256</td>
									<td><code>result</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>8</td>
									<td>bool</td>
									<td><code>addAction</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>9</td>
									<td>bool</td>
									<td><code>active</code></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>changeMiningKey</code> <code class="signature">13340668</code></h3>
							<h4></h4>
							<p>Changes mining key</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="2" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>miningKey</code></td>
									<td>
										<div>
											<p>Current mining key</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>1</td>
									<td>address</td>
									<td><code>miningKeyNew</code></td>
									<td>
										<div>
											<p>New mining key</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>changePayoutKey</code> <code class="signature">181fa47a</code></h3>
							<h4></h4>
							<p>Changes payout key</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="2" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>payoutKey</code></td>
									<td>
										<div>
											<p>Current payout key</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>1</td>
									<td>address</td>
									<td><code>payoutKeyNew</code></td>
									<td>
										<div>
											<p>New payout key</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>changeVotingKey</code> <code class="signature">51d714a8</code></h3>
							<h4></h4>
							<p>Changes voting key</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="2" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>votingKey</code></td>
									<td>
										<div>
											<p>Current voting key</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>1</td>
									<td>address</td>
									<td><code>votingKeyNew</code></td>
									<td>
										<div>
											<p>New voting key</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>checkInitialKey</code> <code class="signature">31567174</code></h3>
							<h4></h4>
							<p>Checks, if initial key is new or not</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>key</code></td>
									<td>
										<div>
											<p>Initial key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Is initial key new or not new</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>checkPayoutKeyValidity</code> <code class="signature">dfecd974</code></h3>
							<h4></h4>
							<p>Checks, if payout key is active or not</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Payout key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Is payout key active or not active</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>checkVotingKeyValidity</code> <code class="signature">f40d9985</code></h3>
							<h4></h4>
							<p>Checks, if voting key is active or not</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Voting key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Is voting key active or not active</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>createKeys</code> <code class="signature">c6232a15</code></h3>
							<h4></h4>
							<p>Create production keys for notary</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="3" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>miningAddr</code></td>
									<td>
										<div>
											<p>Mining key</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>1</td>
									<td>address</td>
									<td><code>payoutAddr</code></td>
									<td>
										<div>
											<p>Payout key</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>2</td>
									<td>address</td>
									<td><code>votingAddr</code></td>
									<td>
										<div>
											<p>Voting key</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>disabledValidators</code> <code class="signature">820e4a24</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>address</td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getBallotAction</code> <code class="signature">a7666dad</code></h3>
							<h4></h4>
							<p>Gets ballot's action</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's action: adding is true, removing is false</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getBallotMemo</code> <code class="signature">11fc7f97</code></h3>
							<h4></h4>
							<p>Gets ballot's memo</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>string</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's memo</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getBallotMiningKey</code> <code class="signature">a88ccf6e</code></h3>
							<h4></h4>
							<p>Gets mining key of notary</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Mining key of notary</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getBallotOwner</code> <code class="signature">8334add4</code></h3>
							<h4></h4>
							<p>Gets ballot's owner full name</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>string</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's owner full name</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getBallotVotingEnd</code> <code class="signature">a59c3408</code></h3>
							<h4></h4>
							<p>Gets ballot's voting end date</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's voting end date</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getBallotVotingStart</code> <code class="signature">2abf367f</code></h3>
							<h4></h4>
							<p>Gets ballot's voting start date</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's voting start date</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getBallots</code> <code class="signature">eb87c6dc</code></h3>
							<h4></h4>
							<p>Gets active ballots' ids</p>
							<table class="ui definition table">
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256[]</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Array of active ballots ids</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getDisabledValidators</code> <code class="signature">3b41c359</code></h3>
							<h4></h4>
							<p>Gets disabled notaries addresses</p>
							<table class="ui definition table">
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>address[]</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Array of disabled notaries addresses</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getValidatorDisablingDate</code> <code class="signature">83e51bc7</code></h3>
							<h4></h4>
							<p>Gets notary's disabling date</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Notary's mining key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Notary's disabling date</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getValidatorFullName</code> <code class="signature">2c48fd0d</code></h3>
							<h4></h4>
							<p>Gets notary's full name</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Notary's mining key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>string</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Notary's full name</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getValidatorLicenseExpiredAt</code> <code class="signature">7d87283a</code></h3>
							<h4></h4>
							<p>Gets notary's license expiration date</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Notary's mining key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Notary's license expiration date</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getValidatorLicenseID</code> <code class="signature">7d667120</code></h3>
							<h4></h4>
							<p>Gets notary's license ID</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Notary's mining key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Notary's license ID</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getValidatorState</code> <code class="signature">5b7d6c36</code></h3>
							<h4></h4>
							<p>Gets notary's state full name</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Notary's mining key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>string</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Notary's state full name</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getValidatorStreetName</code> <code class="signature">5f5f43fe</code></h3>
							<h4></h4>
							<p>Gets notary's address</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Notary's mining key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>string</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Notary's address</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getValidatorZip</code> <code class="signature">e00d1876</code></h3>
							<h4></h4>
							<p>Gets notary's zip code</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td><code>addr</code></td>
									<td>
										<div>
											<p>Notary's mining key</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Notary's zip code</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getValidators</code> <code class="signature">b7ab4db5</code></h3>
							<h4></h4>
							<p>Gets active notaries addresses</p>
							<table class="ui definition table">
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>address[]</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Array of active notaries addresses</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getVotesAgainst</code> <code class="signature">b6f61f66</code></h3>
							<h4></h4>
							<p>Gets ballot's amount of votes against</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>int256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's amount of votes against</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>getVotesFor</code> <code class="signature">d40b65eb</code></h3>
							<h4></h4>
							<p>Gets ballot's amount of votes for</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>int256</td>
									<td><code>value</code></td>
									<td>
										<div>
											<p>Ballot's amount of votes for</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>initialKeys</code> <code class="signature">6bbcdfcd</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>isNew</code></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>miningKeys</code> <code class="signature">20106959</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>isActive</code></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>owner</code> <code class="signature">8da5cb5b</code></h3>
							<table class="ui definition table">
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>address</td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>payoutKeys</code> <code class="signature">40d0f012</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>isActive</code></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>validator</code> <code class="signature">223b3b7a</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="8" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>string</td>
									<td><code>fullName</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>1</td>
									<td>string</td>
									<td><code>streetName</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>2</td>
									<td>string</td>
									<td><code>state</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>3</td>
									<td>uint256</td>
									<td><code>zip</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>4</td>
									<td>uint256</td>
									<td><code>licenseID</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>5</td>
									<td>uint256</td>
									<td><code>licenseExpiredAt</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>6</td>
									<td>uint256</td>
									<td><code>disablingDate</code></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td style="display:none">outputs</td>
									<td>7</td>
									<td>string</td>
									<td><code>disablingTX</code></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>validators</code> <code class="signature">35aa2e44</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>address</td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>vote</code> <code class="signature">c9d27afe</code></h3>
							<h4></h4>
							<p>Votes</p>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="2" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>uint256</td>
									<td><code>ballotID</code></td>
									<td>
										<div>
											<p>Ballot unique ID</p>
										</div>
									</td>
								</tr>
								<tr class="positive">
									<td style="display:none">inputs</td>
									<td>1</td>
									<td>bool</td>
									<td><code>accept</code></td>
									<td>
										<div>
											<p>Vote for is true, vote against is false</p>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>votingKeys</code> <code class="signature">cbebcbbc</code></h3>
							<table class="ui definition table">
								<tr class="positive">
									<td rowspan="1" style="text-transform:capitalize">inputs</td>
									<td>0</td>
									<td>address</td>
									<td></td>
									<td></td>
								</tr>
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>bool</td>
									<td><code>isActive</code></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="ui segment">
							<div class="ui label ribbon right">
								function, constant
							</div>
							<h3 class="ui header" style="margin-top:-1.5rem"><code>votingLowerLimit</code> <code class="signature">f65fb8ab</code></h3>
							<table class="ui definition table">
								<tr class="negative">
									<td rowspan="1" style="text-transform:capitalize">outputs</td>
									<td>0</td>
									<td>uint256</td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
