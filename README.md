# Oracles POA Network smart contracts
Ethereum smart contracts to manage validators in Oracles POA Network 

- [Oracles POA Network smart contracts](#oracles-poa-network-smart-contracts)
  * [Oracles POA Network contracts features checklist](#oracles-poa-network-contracts-features-checklist)
    + [ValidatorsStorage and ValidatorsManager contracts](#validatorsstorage-and-validatorsmanager-contracts)
    + [KeysStorage and KeysManager contracts](#keysstorage-and-keysmanager-contracts)
    + [BallotsStorage and BallotsManager contracts](#ballotsstorage-and-ballotsmanager-contracts)
  * [Known Ethereum contracts attack vectors checklist](#known-ethereum-contracts-attack-vectors-checklist)
  * [Compiling of Oracles contract](#compiling-of-oracles-contract)
  * [How to run tests](#how-to-run-tests)
  * [Oracles contract definition](#oracles-contract-definition)

## Oracles POA Network contracts features checklist

### [ValidatorsStorage](https://github.com/oraclesorg/oracles-contract/blob/master/src/ValidatorsStorage.sol) and [ValidatorsManager](https://github.com/oraclesorg/oracles-contract/blob/master/src/ValidatorsManager.sol) contracts.

These are contracts for storing and managing the data for validators.

| № | Description                                             | Status |
|---|:-----------------------------------------------------|:--------------------------:|
| 1 | Validator's personal data addition is available for valid initial key from ceremony     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 2 | Validator's personal data addition is forbidden for invalid initial key from ceremony    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 3 | Validator's personal data addition is forbidden for the same valid initial key from ceremony twice    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 4 | Validator's personal data addition is forbidden from ceremony, if counter of initial keys, invalidated from ceremony, reached the limit    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 5 | Validator's personal data addition is available for valid voting key from governance     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 6 | Validator's personal data addition is forbidden for invalid voting key from governance    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 7 | Validator's personal data addition is forbidden for the same valid voting key from governance twice    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 8 | Validator's personal data addition is forbidden from governance, if counter of validators, added from governance, reached the limit    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |

### [KeysStorage](https://github.com/oraclesorg/oracles-contract/blob/master/src/KeysStorage.sol) and [KeysManager](https://github.com/oraclesorg/oracles-contract/blob/master/src/KeysManager.sol) contracts.

These are contracts for storing and managing the data for [Oracles POA Network Keys Generation dApp](https://github.com/oraclesorg/oracles-dapps-keys-generation).

| № | Description                                             | Status |
|---|:-----------------------------------------------------|:--------------------------:|
| 1 | Initial key addition is available for contract owner     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 2 | Initial key addition fails to add same key twice    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 3 | Initial key is valid after execution of `addInitialKey` function     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 4 | Initial key generation is forbidden for non-owner of contract    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 5 | It is allowed to add only limited number of initial keys (25)     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 6 | Production keys generation fails for invalid initial key     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 7 | Production keys generation fails for used initial key     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 8 | Licenses counter is incremented by generation of production keys     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 9 | Initial keys invalidation counter is incremented by generation of production keys     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 10 | Mining, voting and payout keys are generated after execution `createKeys`  function, and they are valid     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 11 | Initial key is invalidated immediately after mining/payout/voting keys are created     | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |

### [BallotsStorage](https://github.com/oraclesorg/oracles-contract/blob/master/src/BallotsStorage.sol) and [BallotsManager](https://github.com/oraclesorg/oracles-contract/blob/master/src/BallotsManager.sol) contracts.

These are contracts for storing and managing the data for [Oracles POA Network Governance dApp](https://github.com/oraclesorg/oracles-dapps-voting).

| № | Description                                             | Status |
|---|:-----------------------------------------------------|:--------------------------:|
| 1 | Mining/payout/voting keys can be changed by owner anytime    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 2 | Ballot management is accessed only with valid voting key    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 3 | Ballot creation isn't possible, if limit of licenses distribution (52) is reached    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 4 | Ballot creation to add notary isn't possible, if notary is already added to PoA    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 5 | Ballot creation to add/remove notary isn't possible, if notary was removed from PoA before    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 6 | Voting is accessed only with valid voting key    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 7 | Voter is able to vote for the same ballot only once   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 8 | Voting is prohibited after ballot's expiration    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 9 | Ballot is successfully finished, if total amount of voters >= 3    | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |
| 10 | If ballot is successfully finished, removing or adding of notary is started only if amount of votes for > amount of votes against   | ![good](https://cdn.rawgit.com/primer/octicons/62c672732695b6429678bcd321520c41af109475/build/svg/check.svg) |

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


## How to run tests

* First you need to create symlinks so solidity compiler be able to import contracts from
    oraceles-contract-key, oracles-contract-validator and oracles-contract-ballot directories.
    Just run `make symlinks` command or do it manually (see details in Makefile)
* Then run testrpc with specifica accounts and balances. Use `make testrpc` command.
* Now you can run tests with command `truffle test`.


## Oracles contract definition
<div id="react-mount">
	<div class="wide wide wide column twelve twelve computer mobile sixteen stretched tablet" data-reactid="22">
		<div class="contract" data-reactid="23">
			<div class="ui divider hidden" data-reactid="30" style="clear:both"></div>
			<div class="methods" data-reactid="40">
				<div class="ui segment" data-reactid="41">
					<div class="ui right label ribbon" data-reactid="42">
						function
					</div>
					<h3 class="ui header" data-reactid="44" style="margin-top:-1.5rem"><code data-reactid="45">addBallot</code> <code class="signature" data-reactid="47">9ec5ade2</code></h3>
					<h4 data-reactid="48"></h4>
					<p data-reactid="49">Adds new Ballot</p>
					<table class="ui definition table" data-reactid="51">
						<tbody data-reactid="52">
							<tr class="positive" data-reactid="53">
								<td data-reactid="54" rowspan="7" style="text-transform:capitalize">inputs</td>
								<td data-reactid="55">0</td>
								<td data-reactid="56">uint256</td>
								<td data-reactid="57"><code data-reactid="58">ballotID</code></td>
								<td data-reactid="59">
									<div data-reactid="60">
										<p data-reactid="61">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="63">
								<td data-reactid="65">1</td>
								<td data-reactid="66">address</td>
								<td data-reactid="67"><code data-reactid="68">owner</code></td>
								<td data-reactid="69">
									<div data-reactid="70">
										<p data-reactid="71">Voting key of notary, who creates ballot</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="73">
								<td data-reactid="75">2</td>
								<td data-reactid="76">address</td>
								<td data-reactid="77"><code data-reactid="78">miningKey</code></td>
								<td data-reactid="79">
									<div data-reactid="80">
										<p data-reactid="81">Mining key of notary, which is proposed to add or remove</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="83">
								<td data-reactid="85">3</td>
								<td data-reactid="86">address</td>
								<td data-reactid="87"><code data-reactid="88">affectedKey</code></td>
								<td data-reactid="89">
									<div data-reactid="90">
										<p data-reactid="91">Mining/payout/voting key of notary, which is proposed to add or remove</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="93">
								<td data-reactid="95">4</td>
								<td data-reactid="96">uint256</td>
								<td data-reactid="97"><code data-reactid="98">affectedKeyType</code></td>
								<td data-reactid="99">
									<div data-reactid="100">
										<p data-reactid="101">Type of affectedKey: 0 = mining key, 1 = voting key, 2 = payout key</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="93">
								<td data-reactid="95">4</td>
								<td data-reactid="96">uint256</td>
								<td data-reactid="97"><code data-reactid="98">duration</code></td>
								<td data-reactid="99">
									<div data-reactid="100">
										<p data-reactid="101">Duration of ballot in minutes</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="103">
								<td data-reactid="105">5</td>
								<td data-reactid="106">bool</td>
								<td data-reactid="107"><code data-reactid="108">addAction</code></td>
								<td data-reactid="109">
									<div data-reactid="110">
										<p data-reactid="111">Flag: adding is true, removing is false</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="113">
								<td data-reactid="115">6</td>
								<td data-reactid="116">string</td>
								<td data-reactid="117"><code data-reactid="118">memo</code></td>
								<td data-reactid="119">
									<div data-reactid="120">
										<p data-reactid="121">Ballot's memo</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="123">
					<div class="ui right label ribbon" data-reactid="124">
						function
					</div>
					<h3 class="ui header" data-reactid="126" style="margin-top:-1.5rem"><code data-reactid="127">addInitialKey</code> <code class="signature" data-reactid="129">aff63d5e</code></h3>
					<h4 data-reactid="130"></h4>
					<p data-reactid="131">Adds initial key</p>
					<table class="ui definition table" data-reactid="133">
						<tbody data-reactid="134">
							<tr class="positive" data-reactid="135">
								<td data-reactid="136" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="137">0</td>
								<td data-reactid="138">address</td>
								<td data-reactid="139"><code data-reactid="140">key</code></td>
								<td data-reactid="141">
									<div data-reactid="142">
										<p data-reactid="143">Initial key</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="145">
					<div class="ui right label ribbon" data-reactid="146">
						function
					</div>
					<h3 class="ui header" data-reactid="148" style="margin-top:-1.5rem"><code data-reactid="149">insertValidatorFromCeremony</code> <code class="signature" data-reactid="151">0aeee835</code></h3>
					<h4 data-reactid="152"></h4>
					<p data-reactid="153">Adds new notary's personal info. It is from Ceremony dApp</p>
					<table class="ui definition table" data-reactid="155">
						<tbody data-reactid="156">
							<tr class="positive" data-reactid="157">
								<td data-reactid="158" rowspan="7" style="text-transform:capitalize">inputs</td>
								<td data-reactid="159">0</td>
								<td data-reactid="160">address</td>
								<td data-reactid="161"><code data-reactid="162">miningKey</code></td>
								<td data-reactid="163">
									<div data-reactid="164">
										<p data-reactid="165">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="167">
								<td data-reactid="169">1</td>
								<td data-reactid="170">uint256</td>
								<td data-reactid="171"><code data-reactid="172">zip</code></td>
								<td data-reactid="173">
									<div data-reactid="174">
										<p data-reactid="175">Notary's zip code</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="177">
								<td data-reactid="179">2</td>
								<td data-reactid="180">uint256</td>
								<td data-reactid="181"><code data-reactid="182">licenseID</code></td>
								<td data-reactid="183">
									<div data-reactid="184">
										<p data-reactid="185">Notary's license ID</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="187">
								<td data-reactid="189">3</td>
								<td data-reactid="190">uint256</td>
								<td data-reactid="191"><code data-reactid="192">licenseExpiredAt</code></td>
								<td data-reactid="193">
									<div data-reactid="194">
										<p data-reactid="195">Notary's expiration date</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="197">
								<td data-reactid="199">4</td>
								<td data-reactid="200">string</td>
								<td data-reactid="201"><code data-reactid="202">fullName</code></td>
								<td data-reactid="203">
									<div data-reactid="204">
										<p data-reactid="205">Notary's full name</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="207">
								<td data-reactid="209">5</td>
								<td data-reactid="210">string</td>
								<td data-reactid="211"><code data-reactid="212">streetName</code></td>
								<td data-reactid="213">
									<div data-reactid="214">
										<p data-reactid="215">Notary's address</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="217">
								<td data-reactid="219">6</td>
								<td data-reactid="220">string</td>
								<td data-reactid="221"><code data-reactid="222">state</code></td>
								<td data-reactid="223">
									<div data-reactid="224">
										<p data-reactid="225">Notary's US state full name</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="145">
					<div class="ui right label ribbon" data-reactid="146">
						function
					</div>
					<h3 class="ui header" data-reactid="148" style="margin-top:-1.5rem"><code data-reactid="149">upsertValidatorFromGovernance</code> <code class="signature" data-reactid="151">0aeee835</code></h3>
					<h4 data-reactid="152"></h4>
					<p data-reactid="153">Adds or changes notary's personal info. Both are from Governance dApp</p>
					<table class="ui definition table" data-reactid="155">
						<tbody data-reactid="156">
							<tr class="positive" data-reactid="157">
								<td data-reactid="158" rowspan="7" style="text-transform:capitalize">inputs</td>
								<td data-reactid="159">0</td>
								<td data-reactid="160">address</td>
								<td data-reactid="161"><code data-reactid="162">miningKey</code></td>
								<td data-reactid="163">
									<div data-reactid="164">
										<p data-reactid="165">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="167">
								<td data-reactid="169">1</td>
								<td data-reactid="170">uint256</td>
								<td data-reactid="171"><code data-reactid="172">zip</code></td>
								<td data-reactid="173">
									<div data-reactid="174">
										<p data-reactid="175">Notary's zip code</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="177">
								<td data-reactid="179">2</td>
								<td data-reactid="180">uint256</td>
								<td data-reactid="181"><code data-reactid="182">licenseID</code></td>
								<td data-reactid="183">
									<div data-reactid="184">
										<p data-reactid="185">Notary's license ID</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="187">
								<td data-reactid="189">3</td>
								<td data-reactid="190">uint256</td>
								<td data-reactid="191"><code data-reactid="192">licenseExpiredAt</code></td>
								<td data-reactid="193">
									<div data-reactid="194">
										<p data-reactid="195">Notary's expiration date</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="197">
								<td data-reactid="199">4</td>
								<td data-reactid="200">string</td>
								<td data-reactid="201"><code data-reactid="202">fullName</code></td>
								<td data-reactid="203">
									<div data-reactid="204">
										<p data-reactid="205">Notary's full name</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="207">
								<td data-reactid="209">5</td>
								<td data-reactid="210">string</td>
								<td data-reactid="211"><code data-reactid="212">streetName</code></td>
								<td data-reactid="213">
									<div data-reactid="214">
										<p data-reactid="215">Notary's address</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="217">
								<td data-reactid="219">6</td>
								<td data-reactid="220">string</td>
								<td data-reactid="221"><code data-reactid="222">state</code></td>
								<td data-reactid="223">
									<div data-reactid="224">
										<p data-reactid="225">Notary's US state full name</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="227">
					<div class="ui right label ribbon" data-reactid="228">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="231" style="margin-top:-1.5rem"><code data-reactid="232">ballotCreatedAt</code> <code class="signature" data-reactid="234">b045d117</code></h3>
					<h4 data-reactid="235"></h4>
					<p data-reactid="236">Gets ballot's creation time</p>
					<table class="ui definition table" data-reactid="238">
						<tbody data-reactid="239">
							<tr class="positive" data-reactid="240">
								<td data-reactid="241" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="242">0</td>
								<td data-reactid="243">uint256</td>
								<td data-reactid="244"><code data-reactid="245">ballotID</code></td>
								<td data-reactid="246">
									<div data-reactid="247">
										<p data-reactid="248">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="250">
								<td data-reactid="251" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="252">0</td>
								<td data-reactid="253">uint256</td>
								<td data-reactid="254"><code data-reactid="255">value</code></td>
								<td data-reactid="256">
									<div data-reactid="257">
										<p data-reactid="258">Ballot's creation time</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="260">
					<div class="ui right label ribbon" data-reactid="261">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="264" style="margin-top:-1.5rem"><code data-reactid="265">ballotIsActive</code> <code class="signature" data-reactid="267">75f358cc</code></h3>
					<h4 data-reactid="268"></h4>
					<p data-reactid="269">Checks, if ballot is active</p>
					<table class="ui definition table" data-reactid="271">
						<tbody data-reactid="272">
							<tr class="positive" data-reactid="273">
								<td data-reactid="274" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="275">0</td>
								<td data-reactid="276">uint256</td>
								<td data-reactid="277"><code data-reactid="278">ballotID</code></td>
								<td data-reactid="279">
									<div data-reactid="280">
										<p data-reactid="281">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="283">
								<td data-reactid="284" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="285">0</td>
								<td data-reactid="286">bool</td>
								<td data-reactid="287"><code data-reactid="288">value</code></td>
								<td data-reactid="289">
									<div data-reactid="290">
										<p data-reactid="291">Ballot's activity: active or not</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="293">
					<div class="ui right label ribbon" data-reactid="294">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="297" style="margin-top:-1.5rem"><code data-reactid="298">ballotIsVoted</code> <code class="signature" data-reactid="300">6f2dc1c1</code></h3>
					<h4 data-reactid="301"></h4>
					<p data-reactid="302">Checks, if ballot is already voted by signer of current transaction</p>
					<table class="ui definition table" data-reactid="304">
						<tbody data-reactid="305">
							<tr class="positive" data-reactid="306">
								<td data-reactid="307" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="308">0</td>
								<td data-reactid="309">uint256</td>
								<td data-reactid="310"><code data-reactid="311">ballotID</code></td>
								<td data-reactid="312">
									<div data-reactid="313">
										<p data-reactid="314">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="316">
								<td data-reactid="317" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="318">0</td>
								<td data-reactid="319">bool</td>
								<td data-reactid="320"><code data-reactid="321">value</code></td>
								<td data-reactid="322">
									<div data-reactid="323">
										<p data-reactid="324">Ballot is already voted by signer of current transaction: yes or no</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="326">
					<div class="ui right label ribbon" data-reactid="327">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="330" style="margin-top:-1.5rem"><code data-reactid="331">ballots</code> <code class="signature" data-reactid="333">5c632b38</code></h3>
					<table class="ui definition table" data-reactid="334">
						<tbody data-reactid="335">
							<tr class="positive" data-reactid="336">
								<td data-reactid="337" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="338">0</td>
								<td data-reactid="339">uint256</td>
								<td data-reactid="340"></td>
								<td data-reactid="341"></td>
							</tr>
							<tr class="negative" data-reactid="342">
								<td data-reactid="343" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="344">0</td>
								<td data-reactid="345">uint256</td>
								<td data-reactid="346"></td>
								<td data-reactid="347"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="348">
					<div class="ui right label ribbon" data-reactid="349">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="352" style="margin-top:-1.5rem"><code data-reactid="353">ballotsMapping</code> <code class="signature" data-reactid="355">32d21d00</code></h3>
					<table class="ui definition table" data-reactid="356">
						<tbody data-reactid="357">
							<tr class="positive" data-reactid="358">
								<td data-reactid="359" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="360">0</td>
								<td data-reactid="361">uint256</td>
								<td data-reactid="362"></td>
								<td data-reactid="363"></td>
							</tr>
							<tr class="negative" data-reactid="364">
								<td data-reactid="365" rowspan="12" style="text-transform:capitalize">outputs</td>
								<td data-reactid="366">0</td>
								<td data-reactid="367">address</td>
								<td data-reactid="368"><code data-reactid="369">owner</code></td>
								<td data-reactid="370"></td>
							</tr>
							<tr class="negative" data-reactid="371">
								<td data-reactid="373">1</td>
								<td data-reactid="374">address</td>
								<td data-reactid="375"><code data-reactid="376">miningKey</code></td>
								<td data-reactid="377"></td>
							</tr>
							<tr class="negative" data-reactid="378">
								<td data-reactid="380">2</td>
								<td data-reactid="381">address</td>
								<td data-reactid="382"><code data-reactid="383">affectedKey</code></td>
								<td data-reactid="384"></td>
							</tr>
							<tr class="negative" data-reactid="385">
								<td data-reactid="387">3</td>
								<td data-reactid="388">string</td>
								<td data-reactid="389"><code data-reactid="390">memo</code></td>
								<td data-reactid="391"></td>
							</tr>
							<tr class="negative" data-reactid="392">
								<td data-reactid="394">4</td>
								<td data-reactid="395">uint256</td>
								<td data-reactid="396"><code data-reactid="397">affectedKeyType</code></td>
								<td data-reactid="398"></td>
							</tr>
							<tr class="negative" data-reactid="399">
								<td data-reactid="401">5</td>
								<td data-reactid="402">uint256</td>
								<td data-reactid="403"><code data-reactid="404">createdAt</code></td>
								<td data-reactid="405"></td>
							</tr>
							<tr class="negative" data-reactid="406">
								<td data-reactid="408">6</td>
								<td data-reactid="409">uint256</td>
								<td data-reactid="410"><code data-reactid="411">votingStart</code></td>
								<td data-reactid="412"></td>
							</tr>
							<tr class="negative" data-reactid="413">
								<td data-reactid="415">7</td>
								<td data-reactid="416">uint256</td>
								<td data-reactid="417"><code data-reactid="418">votingDeadline</code></td>
								<td data-reactid="419"></td>
							</tr>
							<tr class="negative" data-reactid="420">
								<td data-reactid="422">8</td>
								<td data-reactid="423">int256</td>
								<td data-reactid="424"><code data-reactid="425">votesAmmount</code></td>
								<td data-reactid="426"></td>
							</tr>
							<tr class="negative" data-reactid="427">
								<td data-reactid="429">9</td>
								<td data-reactid="430">int256</td>
								<td data-reactid="431"><code data-reactid="432">result</code></td>
								<td data-reactid="433"></td>
							</tr>
							<tr class="negative" data-reactid="434">
								<td data-reactid="436">10</td>
								<td data-reactid="437">bool</td>
								<td data-reactid="438"><code data-reactid="439">addAction</code></td>
								<td data-reactid="440"></td>
							</tr>
							<tr class="negative" data-reactid="441">
								<td data-reactid="443">11</td>
								<td data-reactid="444">bool</td>
								<td data-reactid="445"><code data-reactid="446">active</code></td>
								<td data-reactid="447"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="448">
					<div class="ui right label ribbon" data-reactid="449">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="452" style="margin-top:-1.5rem"><code data-reactid="453">checkInitialKey</code> <code class="signature" data-reactid="455">31567174</code></h3>
					<h4 data-reactid="456"></h4>
					<p data-reactid="457">Checks, if initial key is new or not</p>
					<table class="ui definition table" data-reactid="459">
						<tbody data-reactid="460">
							<tr class="positive" data-reactid="461">
								<td data-reactid="462" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="463">0</td>
								<td data-reactid="464">address</td>
								<td data-reactid="465"><code data-reactid="466">key</code></td>
								<td data-reactid="467">
									<div data-reactid="468">
										<p data-reactid="469">Initial key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="471">
								<td data-reactid="472" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="473">0</td>
								<td data-reactid="474">bool</td>
								<td data-reactid="475"><code data-reactid="476">value</code></td>
								<td data-reactid="477">
									<div data-reactid="478">
										<p data-reactid="479">Is initial key new or not new</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="481">
					<div class="ui right label ribbon" data-reactid="482">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="485" style="margin-top:-1.5rem"><code data-reactid="486">checkPayoutKeyValidity</code> <code class="signature" data-reactid="488">dfecd974</code></h3>
					<h4 data-reactid="489"></h4>
					<p data-reactid="490">Checks, if payout key is active or not</p>
					<table class="ui definition table" data-reactid="492">
						<tbody data-reactid="493">
							<tr class="positive" data-reactid="494">
								<td data-reactid="495" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="496">0</td>
								<td data-reactid="497">address</td>
								<td data-reactid="498"><code data-reactid="499">addr</code></td>
								<td data-reactid="500">
									<div data-reactid="501">
										<p data-reactid="502">Payout key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="504">
								<td data-reactid="505" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="506">0</td>
								<td data-reactid="507">bool</td>
								<td data-reactid="508"><code data-reactid="509">value</code></td>
								<td data-reactid="510">
									<div data-reactid="511">
										<p data-reactid="512">Is payout key active or not active</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="514">
					<div class="ui right label ribbon" data-reactid="515">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="518" style="margin-top:-1.5rem"><code data-reactid="519">checkVotingKeyValidity</code> <code class="signature" data-reactid="521">f40d9985</code></h3>
					<h4 data-reactid="522"></h4>
					<p data-reactid="523">Checks, if voting key is active or not</p>
					<table class="ui definition table" data-reactid="525">
						<tbody data-reactid="526">
							<tr class="positive" data-reactid="527">
								<td data-reactid="528" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="529">0</td>
								<td data-reactid="530">address</td>
								<td data-reactid="531"><code data-reactid="532">addr</code></td>
								<td data-reactid="533">
									<div data-reactid="534">
										<p data-reactid="535">Voting key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="537">
								<td data-reactid="538" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="539">0</td>
								<td data-reactid="540">bool</td>
								<td data-reactid="541"><code data-reactid="542">value</code></td>
								<td data-reactid="543">
									<div data-reactid="544">
										<p data-reactid="545">Is voting key active or not active</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="547">
					<div class="ui right label ribbon" data-reactid="548">
						function
					</div>
					<h3 class="ui header" data-reactid="550" style="margin-top:-1.5rem"><code data-reactid="551">createKeys</code> <code class="signature" data-reactid="553">c6232a15</code></h3>
					<h4 data-reactid="554"></h4>
					<p data-reactid="555">Create production keys for notary</p>
					<table class="ui definition table" data-reactid="557">
						<tbody data-reactid="558">
							<tr class="positive" data-reactid="559">
								<td data-reactid="560" rowspan="3" style="text-transform:capitalize">inputs</td>
								<td data-reactid="561">0</td>
								<td data-reactid="562">address</td>
								<td data-reactid="563"><code data-reactid="564">miningAddr</code></td>
								<td data-reactid="565">
									<div data-reactid="566">
										<p data-reactid="567">Mining key</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="569">
								<td data-reactid="571">1</td>
								<td data-reactid="572">address</td>
								<td data-reactid="573"><code data-reactid="574">payoutAddr</code></td>
								<td data-reactid="575">
									<div data-reactid="576">
										<p data-reactid="577">Payout key</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="579">
								<td data-reactid="581">2</td>
								<td data-reactid="582">address</td>
								<td data-reactid="583"><code data-reactid="584">votingAddr</code></td>
								<td data-reactid="585">
									<div data-reactid="586">
										<p data-reactid="587">Voting key</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="589">
					<div class="ui right label ribbon" data-reactid="590">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="593" style="margin-top:-1.5rem"><code data-reactid="594">disabledValidators</code> <code class="signature" data-reactid="596">820e4a24</code></h3>
					<table class="ui definition table" data-reactid="597">
						<tbody data-reactid="598">
							<tr class="positive" data-reactid="599">
								<td data-reactid="600" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="601">0</td>
								<td data-reactid="602">uint256</td>
								<td data-reactid="603"></td>
								<td data-reactid="604"></td>
							</tr>
							<tr class="negative" data-reactid="605">
								<td data-reactid="606" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="607">0</td>
								<td data-reactid="608">address</td>
								<td data-reactid="609"></td>
								<td data-reactid="610"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="611">
					<div class="ui right label ribbon" data-reactid="612">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="615" style="margin-top:-1.5rem"><code data-reactid="616">getBallotAction</code> <code class="signature" data-reactid="618">a7666dad</code></h3>
					<h4 data-reactid="619"></h4>
					<p data-reactid="620">Gets ballot's action</p>
					<table class="ui definition table" data-reactid="622">
						<tbody data-reactid="623">
							<tr class="positive" data-reactid="624">
								<td data-reactid="625" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="626">0</td>
								<td data-reactid="627">uint256</td>
								<td data-reactid="628"><code data-reactid="629">ballotID</code></td>
								<td data-reactid="630">
									<div data-reactid="631">
										<p data-reactid="632">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="634">
								<td data-reactid="635" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="636">0</td>
								<td data-reactid="637">bool</td>
								<td data-reactid="638"><code data-reactid="639">value</code></td>
								<td data-reactid="640">
									<div data-reactid="641">
										<p data-reactid="642">Ballot's action: adding is true, removing is false</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="644">
					<div class="ui right label ribbon" data-reactid="645">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="648" style="margin-top:-1.5rem"><code data-reactid="649">getBallotAffectedKey</code> <code class="signature" data-reactid="651">075f1d47</code></h3>
					<h4 data-reactid="652"></h4>
					<p data-reactid="653">Gets affected key of ballot</p>
					<table class="ui definition table" data-reactid="655">
						<tbody data-reactid="656">
							<tr class="positive" data-reactid="657">
								<td data-reactid="658" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="659">0</td>
								<td data-reactid="660">uint256</td>
								<td data-reactid="661"><code data-reactid="662">ballotID</code></td>
								<td data-reactid="663">
									<div data-reactid="664">
										<p data-reactid="665">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="667">
								<td data-reactid="668" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="669">0</td>
								<td data-reactid="670">address</td>
								<td data-reactid="671"><code data-reactid="672">value</code></td>
								<td data-reactid="673">
									<div data-reactid="674">
										<p data-reactid="675">Ballot's affected key</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="677">
					<div class="ui right label ribbon" data-reactid="678">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="681" style="margin-top:-1.5rem"><code data-reactid="682">getBallotAffectedKeyType</code> <code class="signature" data-reactid="684">a411e345</code></h3>
					<h4 data-reactid="685"></h4>
					<p data-reactid="686">Gets affected key type of ballot</p>
					<table class="ui definition table" data-reactid="688">
						<tbody data-reactid="689">
							<tr class="positive" data-reactid="690">
								<td data-reactid="691" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="692">0</td>
								<td data-reactid="693">uint256</td>
								<td data-reactid="694"><code data-reactid="695">ballotID</code></td>
								<td data-reactid="696">
									<div data-reactid="697">
										<p data-reactid="698">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="700">
								<td data-reactid="701" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="702">0</td>
								<td data-reactid="703">uint256</td>
								<td data-reactid="704"><code data-reactid="705">value</code></td>
								<td data-reactid="706">
									<div data-reactid="707">
										<p data-reactid="708">Ballot's affected key type</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="710">
					<div class="ui right label ribbon" data-reactid="711">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="714" style="margin-top:-1.5rem"><code data-reactid="715">getBallotMemo</code> <code class="signature" data-reactid="717">11fc7f97</code></h3>
					<h4 data-reactid="718"></h4>
					<p data-reactid="719">Gets ballot's memo</p>
					<table class="ui definition table" data-reactid="721">
						<tbody data-reactid="722">
							<tr class="positive" data-reactid="723">
								<td data-reactid="724" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="725">0</td>
								<td data-reactid="726">uint256</td>
								<td data-reactid="727"><code data-reactid="728">ballotID</code></td>
								<td data-reactid="729">
									<div data-reactid="730">
										<p data-reactid="731">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="733">
								<td data-reactid="734" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="735">0</td>
								<td data-reactid="736">string</td>
								<td data-reactid="737"><code data-reactid="738">value</code></td>
								<td data-reactid="739">
									<div data-reactid="740">
										<p data-reactid="741">Ballot's memo</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="743">
					<div class="ui right label ribbon" data-reactid="744">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="747" style="margin-top:-1.5rem"><code data-reactid="748">getBallotMiningKey</code> <code class="signature" data-reactid="750">a88ccf6e</code></h3>
					<h4 data-reactid="751"></h4>
					<p data-reactid="752">Gets mining key of notary</p>
					<table class="ui definition table" data-reactid="754">
						<tbody data-reactid="755">
							<tr class="positive" data-reactid="756">
								<td data-reactid="757" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="758">0</td>
								<td data-reactid="759">uint256</td>
								<td data-reactid="760"><code data-reactid="761">ballotID</code></td>
								<td data-reactid="762">
									<div data-reactid="763">
										<p data-reactid="764">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="766">
								<td data-reactid="767" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="768">0</td>
								<td data-reactid="769">address</td>
								<td data-reactid="770"><code data-reactid="771">value</code></td>
								<td data-reactid="772">
									<div data-reactid="773">
										<p data-reactid="774">Notary's mining key</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="776">
					<div class="ui right label ribbon" data-reactid="777">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="780" style="margin-top:-1.5rem"><code data-reactid="781">getBallotOwner</code> <code class="signature" data-reactid="783">8334add4</code></h3>
					<h4 data-reactid="784"></h4>
					<p data-reactid="785">Gets ballot's owner full name</p>
					<table class="ui definition table" data-reactid="787">
						<tbody data-reactid="788">
							<tr class="positive" data-reactid="789">
								<td data-reactid="790" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="791">0</td>
								<td data-reactid="792">uint256</td>
								<td data-reactid="793"><code data-reactid="794">ballotID</code></td>
								<td data-reactid="795">
									<div data-reactid="796">
										<p data-reactid="797">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="799">
								<td data-reactid="800" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="801">0</td>
								<td data-reactid="802">string</td>
								<td data-reactid="803"><code data-reactid="804">value</code></td>
								<td data-reactid="805">
									<div data-reactid="806">
										<p data-reactid="807">Ballot's owner full name</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="809">
					<div class="ui right label ribbon" data-reactid="810">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="813" style="margin-top:-1.5rem"><code data-reactid="814">getBallotVotingEnd</code> <code class="signature" data-reactid="816">a59c3408</code></h3>
					<h4 data-reactid="817"></h4>
					<p data-reactid="818">Gets ballot's voting end date</p>
					<table class="ui definition table" data-reactid="820">
						<tbody data-reactid="821">
							<tr class="positive" data-reactid="822">
								<td data-reactid="823" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="824">0</td>
								<td data-reactid="825">uint256</td>
								<td data-reactid="826"><code data-reactid="827">ballotID</code></td>
								<td data-reactid="828">
									<div data-reactid="829">
										<p data-reactid="830">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="832">
								<td data-reactid="833" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="834">0</td>
								<td data-reactid="835">uint256</td>
								<td data-reactid="836"><code data-reactid="837">value</code></td>
								<td data-reactid="838">
									<div data-reactid="839">
										<p data-reactid="840">Ballot's voting end date</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="842">
					<div class="ui right label ribbon" data-reactid="843">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="846" style="margin-top:-1.5rem"><code data-reactid="847">getBallotVotingStart</code> <code class="signature" data-reactid="849">2abf367f</code></h3>
					<h4 data-reactid="850"></h4>
					<p data-reactid="851">Gets ballot's voting start date</p>
					<table class="ui definition table" data-reactid="853">
						<tbody data-reactid="854">
							<tr class="positive" data-reactid="855">
								<td data-reactid="856" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="857">0</td>
								<td data-reactid="858">uint256</td>
								<td data-reactid="859"><code data-reactid="860">ballotID</code></td>
								<td data-reactid="861">
									<div data-reactid="862">
										<p data-reactid="863">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="865">
								<td data-reactid="866" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="867">0</td>
								<td data-reactid="868">uint256</td>
								<td data-reactid="869"><code data-reactid="870">value</code></td>
								<td data-reactid="871">
									<div data-reactid="872">
										<p data-reactid="873">Ballot's voting start date</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="875">
					<div class="ui right label ribbon" data-reactid="876">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="879" style="margin-top:-1.5rem"><code data-reactid="880">getBallots</code> <code class="signature" data-reactid="882">eb87c6dc</code></h3>
					<h4 data-reactid="883"></h4>
					<p data-reactid="884">Gets all ballots' ids</p>
					<table class="ui definition table" data-reactid="886">
						<tbody data-reactid="887">
							<tr class="negative" data-reactid="888">
								<td data-reactid="889" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="890">0</td>
								<td data-reactid="891">uint256[]</td>
								<td data-reactid="892"><code data-reactid="893">value</code></td>
								<td data-reactid="894">
									<div data-reactid="895">
										<p data-reactid="896">Array of all ballots ids</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="898">
					<div class="ui right label ribbon" data-reactid="899">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="902" style="margin-top:-1.5rem"><code data-reactid="903">getDisabledValidators</code> <code class="signature" data-reactid="905">3b41c359</code></h3>
					<h4 data-reactid="906"></h4>
					<p data-reactid="907">Gets disabled notaries mining keys</p>
					<table class="ui definition table" data-reactid="909">
						<tbody data-reactid="910">
							<tr class="negative" data-reactid="911">
								<td data-reactid="912" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="913">0</td>
								<td data-reactid="914">address[]</td>
								<td data-reactid="915"><code data-reactid="916">value</code></td>
								<td data-reactid="917">
									<div data-reactid="918">
										<p data-reactid="919">Array of disabled notaries mining keys</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="921">
					<div class="ui right label ribbon" data-reactid="922">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="925" style="margin-top:-1.5rem"><code data-reactid="926">getValidatorDisablingDate</code> <code class="signature" data-reactid="928">83e51bc7</code></h3>
					<h4 data-reactid="929"></h4>
					<p data-reactid="930">Gets notary's disabling date</p>
					<table class="ui definition table" data-reactid="932">
						<tbody data-reactid="933">
							<tr class="positive" data-reactid="934">
								<td data-reactid="935" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="936">0</td>
								<td data-reactid="937">address</td>
								<td data-reactid="938"><code data-reactid="939">addr</code></td>
								<td data-reactid="940">
									<div data-reactid="941">
										<p data-reactid="942">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="944">
								<td data-reactid="945" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="946">0</td>
								<td data-reactid="947">uint256</td>
								<td data-reactid="948"><code data-reactid="949">value</code></td>
								<td data-reactid="950">
									<div data-reactid="951">
										<p data-reactid="952">Notary's disabling date</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="954">
					<div class="ui right label ribbon" data-reactid="955">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="958" style="margin-top:-1.5rem"><code data-reactid="959">getValidatorFullName</code> <code class="signature" data-reactid="961">2c48fd0d</code></h3>
					<h4 data-reactid="962"></h4>
					<p data-reactid="963">Gets notary's full name</p>
					<table class="ui definition table" data-reactid="965">
						<tbody data-reactid="966">
							<tr class="positive" data-reactid="967">
								<td data-reactid="968" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="969">0</td>
								<td data-reactid="970">address</td>
								<td data-reactid="971"><code data-reactid="972">addr</code></td>
								<td data-reactid="973">
									<div data-reactid="974">
										<p data-reactid="975">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="977">
								<td data-reactid="978" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="979">0</td>
								<td data-reactid="980">string</td>
								<td data-reactid="981"><code data-reactid="982">value</code></td>
								<td data-reactid="983">
									<div data-reactid="984">
										<p data-reactid="985">Notary's full name</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="987">
					<div class="ui right label ribbon" data-reactid="988">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="991" style="margin-top:-1.5rem"><code data-reactid="992">getValidatorLicenseExpiredAt</code> <code class="signature" data-reactid="994">7d87283a</code></h3>
					<h4 data-reactid="995"></h4>
					<p data-reactid="996">Gets notary's license expiration date</p>
					<table class="ui definition table" data-reactid="998">
						<tbody data-reactid="999">
							<tr class="positive" data-reactid="1000">
								<td data-reactid="1001" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1002">0</td>
								<td data-reactid="1003">address</td>
								<td data-reactid="1004"><code data-reactid="1005">addr</code></td>
								<td data-reactid="1006">
									<div data-reactid="1007">
										<p data-reactid="1008">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="1010">
								<td data-reactid="1011" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1012">0</td>
								<td data-reactid="1013">uint256</td>
								<td data-reactid="1014"><code data-reactid="1015">value</code></td>
								<td data-reactid="1016">
									<div data-reactid="1017">
										<p data-reactid="1018">Notary's license expiration date</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1020">
					<div class="ui right label ribbon" data-reactid="1021">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1024" style="margin-top:-1.5rem"><code data-reactid="1025">getValidatorLicenseID</code> <code class="signature" data-reactid="1027">7d667120</code></h3>
					<h4 data-reactid="1028"></h4>
					<p data-reactid="1029">Gets notary's license ID</p>
					<table class="ui definition table" data-reactid="1031">
						<tbody data-reactid="1032">
							<tr class="positive" data-reactid="1033">
								<td data-reactid="1034" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1035">0</td>
								<td data-reactid="1036">address</td>
								<td data-reactid="1037"><code data-reactid="1038">addr</code></td>
								<td data-reactid="1039">
									<div data-reactid="1040">
										<p data-reactid="1041">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="1043">
								<td data-reactid="1044" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1045">0</td>
								<td data-reactid="1046">uint256</td>
								<td data-reactid="1047"><code data-reactid="1048">value</code></td>
								<td data-reactid="1049">
									<div data-reactid="1050">
										<p data-reactid="1051">Notary's license ID</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1053">
					<div class="ui right label ribbon" data-reactid="1054">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1057" style="margin-top:-1.5rem"><code data-reactid="1058">getValidatorState</code> <code class="signature" data-reactid="1060">5b7d6c36</code></h3>
					<h4 data-reactid="1061"></h4>
					<p data-reactid="1062">Gets notary's state full name</p>
					<table class="ui definition table" data-reactid="1064">
						<tbody data-reactid="1065">
							<tr class="positive" data-reactid="1066">
								<td data-reactid="1067" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1068">0</td>
								<td data-reactid="1069">address</td>
								<td data-reactid="1070"><code data-reactid="1071">addr</code></td>
								<td data-reactid="1072">
									<div data-reactid="1073">
										<p data-reactid="1074">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="1076">
								<td data-reactid="1077" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1078">0</td>
								<td data-reactid="1079">string</td>
								<td data-reactid="1080"><code data-reactid="1081">value</code></td>
								<td data-reactid="1082">
									<div data-reactid="1083">
										<p data-reactid="1084">Notary's state full name</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1086">
					<div class="ui right label ribbon" data-reactid="1087">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1090" style="margin-top:-1.5rem"><code data-reactid="1091">getValidatorStreetName</code> <code class="signature" data-reactid="1093">5f5f43fe</code></h3>
					<h4 data-reactid="1094"></h4>
					<p data-reactid="1095">Gets notary's address</p>
					<table class="ui definition table" data-reactid="1097">
						<tbody data-reactid="1098">
							<tr class="positive" data-reactid="1099">
								<td data-reactid="1100" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1101">0</td>
								<td data-reactid="1102">address</td>
								<td data-reactid="1103"><code data-reactid="1104">addr</code></td>
								<td data-reactid="1105">
									<div data-reactid="1106">
										<p data-reactid="1107">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="1109">
								<td data-reactid="1110" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1111">0</td>
								<td data-reactid="1112">string</td>
								<td data-reactid="1113"><code data-reactid="1114">value</code></td>
								<td data-reactid="1115">
									<div data-reactid="1116">
										<p data-reactid="1117">Notary's address</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1119">
					<div class="ui right label ribbon" data-reactid="1120">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1123" style="margin-top:-1.5rem"><code data-reactid="1124">getValidatorZip</code> <code class="signature" data-reactid="1126">e00d1876</code></h3>
					<h4 data-reactid="1127"></h4>
					<p data-reactid="1128">Gets notary's zip code</p>
					<table class="ui definition table" data-reactid="1130">
						<tbody data-reactid="1131">
							<tr class="positive" data-reactid="1132">
								<td data-reactid="1133" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1134">0</td>
								<td data-reactid="1135">address</td>
								<td data-reactid="1136"><code data-reactid="1137">addr</code></td>
								<td data-reactid="1138">
									<div data-reactid="1139">
										<p data-reactid="1140">Notary's mining key</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="1142">
								<td data-reactid="1143" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1144">0</td>
								<td data-reactid="1145">uint256</td>
								<td data-reactid="1146"><code data-reactid="1147">value</code></td>
								<td data-reactid="1148">
									<div data-reactid="1149">
										<p data-reactid="1150">Notary's zip code</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1152">
					<div class="ui right label ribbon" data-reactid="1153">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1156" style="margin-top:-1.5rem"><code data-reactid="1157">getValidators</code> <code class="signature" data-reactid="1159">b7ab4db5</code></h3>
					<h4 data-reactid="1160"></h4>
					<p data-reactid="1161">Gets active notaries mining keys</p>
					<table class="ui definition table" data-reactid="1163">
						<tbody data-reactid="1164">
							<tr class="negative" data-reactid="1165">
								<td data-reactid="1166" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1167">0</td>
								<td data-reactid="1168">address[]</td>
								<td data-reactid="1169"><code data-reactid="1170">value</code></td>
								<td data-reactid="1171">
									<div data-reactid="1172">
										<p data-reactid="1173">Array of active notaries mining keys</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1175">
					<div class="ui right label ribbon" data-reactid="1176">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1179" style="margin-top:-1.5rem"><code data-reactid="1180">getVotesAgainst</code> <code class="signature" data-reactid="1182">b6f61f66</code></h3>
					<h4 data-reactid="1183"></h4>
					<p data-reactid="1184">Gets ballot's amount of votes against</p>
					<table class="ui definition table" data-reactid="1186">
						<tbody data-reactid="1187">
							<tr class="positive" data-reactid="1188">
								<td data-reactid="1189" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1190">0</td>
								<td data-reactid="1191">uint256</td>
								<td data-reactid="1192"><code data-reactid="1193">ballotID</code></td>
								<td data-reactid="1194">
									<div data-reactid="1195">
										<p data-reactid="1196">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="1198">
								<td data-reactid="1199" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1200">0</td>
								<td data-reactid="1201">int256</td>
								<td data-reactid="1202"><code data-reactid="1203">value</code></td>
								<td data-reactid="1204">
									<div data-reactid="1205">
										<p data-reactid="1206">Ballot's amount of votes against</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1208">
					<div class="ui right label ribbon" data-reactid="1209">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1212" style="margin-top:-1.5rem"><code data-reactid="1213">getVotesFor</code> <code class="signature" data-reactid="1215">d40b65eb</code></h3>
					<h4 data-reactid="1216"></h4>
					<p data-reactid="1217">Gets ballot's amount of votes for</p>
					<table class="ui definition table" data-reactid="1219">
						<tbody data-reactid="1220">
							<tr class="positive" data-reactid="1221">
								<td data-reactid="1222" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1223">0</td>
								<td data-reactid="1224">uint256</td>
								<td data-reactid="1225"><code data-reactid="1226">ballotID</code></td>
								<td data-reactid="1227">
									<div data-reactid="1228">
										<p data-reactid="1229">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="negative" data-reactid="1231">
								<td data-reactid="1232" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1233">0</td>
								<td data-reactid="1234">int256</td>
								<td data-reactid="1235"><code data-reactid="1236">value</code></td>
								<td data-reactid="1237">
									<div data-reactid="1238">
										<p data-reactid="1239">Ballot's amount of votes for</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1241">
					<div class="ui right label ribbon" data-reactid="1242">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1245" style="margin-top:-1.5rem"><code data-reactid="1246">initialKeys</code> <code class="signature" data-reactid="1248">6bbcdfcd</code></h3>
					<table class="ui definition table" data-reactid="1249">
						<tbody data-reactid="1250">
							<tr class="positive" data-reactid="1251">
								<td data-reactid="1252" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1253">0</td>
								<td data-reactid="1254">address</td>
								<td data-reactid="1255"></td>
								<td data-reactid="1256"></td>
							</tr>
							<tr class="negative" data-reactid="1257">
								<td data-reactid="1258" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1259">0</td>
								<td data-reactid="1260">bool</td>
								<td data-reactid="1261"><code data-reactid="1262">isNew</code></td>
								<td data-reactid="1263"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1264">
					<div class="ui right label ribbon" data-reactid="1265">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1268" style="margin-top:-1.5rem"><code data-reactid="1269">miningKeys</code> <code class="signature" data-reactid="1271">20106959</code></h3>
					<table class="ui definition table" data-reactid="1272">
						<tbody data-reactid="1273">
							<tr class="positive" data-reactid="1274">
								<td data-reactid="1275" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1276">0</td>
								<td data-reactid="1277">address</td>
								<td data-reactid="1278"></td>
								<td data-reactid="1279"></td>
							</tr>
							<tr class="negative" data-reactid="1280">
								<td data-reactid="1281" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1282">0</td>
								<td data-reactid="1283">bool</td>
								<td data-reactid="1284"><code data-reactid="1285">isActive</code></td>
								<td data-reactid="1286"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1287">
					<div class="ui right label ribbon" data-reactid="1288">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1291" style="margin-top:-1.5rem"><code data-reactid="1292">owner</code> <code class="signature" data-reactid="1294">8da5cb5b</code></h3>
					<table class="ui definition table" data-reactid="1295">
						<tbody data-reactid="1296">
							<tr class="negative" data-reactid="1297">
								<td data-reactid="1298" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1299">0</td>
								<td data-reactid="1300">address</td>
								<td data-reactid="1301"></td>
								<td data-reactid="1302"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1303">
					<div class="ui right label ribbon" data-reactid="1304">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1307" style="margin-top:-1.5rem"><code data-reactid="1308">payoutKeys</code> <code class="signature" data-reactid="1310">40d0f012</code></h3>
					<table class="ui definition table" data-reactid="1311">
						<tbody data-reactid="1312">
							<tr class="positive" data-reactid="1313">
								<td data-reactid="1314" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1315">0</td>
								<td data-reactid="1316">address</td>
								<td data-reactid="1317"></td>
								<td data-reactid="1318"></td>
							</tr>
							<tr class="negative" data-reactid="1319">
								<td data-reactid="1320" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1321">0</td>
								<td data-reactid="1322">bool</td>
								<td data-reactid="1323"><code data-reactid="1324">isActive</code></td>
								<td data-reactid="1325"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1326">
					<div class="ui right label ribbon" data-reactid="1327">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1330" style="margin-top:-1.5rem"><code data-reactid="1331">validator</code> <code class="signature" data-reactid="1333">223b3b7a</code></h3>
					<table class="ui definition table" data-reactid="1334">
						<tbody data-reactid="1335">
							<tr class="positive" data-reactid="1336">
								<td data-reactid="1337" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1338">0</td>
								<td data-reactid="1339">address</td>
								<td data-reactid="1340"></td>
								<td data-reactid="1341"></td>
							</tr>
							<tr class="negative" data-reactid="1342">
								<td data-reactid="1343" rowspan="8" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1344">0</td>
								<td data-reactid="1345">string</td>
								<td data-reactid="1346"><code data-reactid="1347">fullName</code></td>
								<td data-reactid="1348"></td>
							</tr>
							<tr class="negative" data-reactid="1349">
								<td data-reactid="1351">1</td>
								<td data-reactid="1352">string</td>
								<td data-reactid="1353"><code data-reactid="1354">streetName</code></td>
								<td data-reactid="1355"></td>
							</tr>
							<tr class="negative" data-reactid="1356">
								<td data-reactid="1358">2</td>
								<td data-reactid="1359">string</td>
								<td data-reactid="1360"><code data-reactid="1361">state</code></td>
								<td data-reactid="1362"></td>
							</tr>
							<tr class="negative" data-reactid="1363">
								<td data-reactid="1365">3</td>
								<td data-reactid="1366">uint256</td>
								<td data-reactid="1367"><code data-reactid="1368">zip</code></td>
								<td data-reactid="1369"></td>
							</tr>
							<tr class="negative" data-reactid="1370">
								<td data-reactid="1372">4</td>
								<td data-reactid="1373">uint256</td>
								<td data-reactid="1374"><code data-reactid="1375">licenseID</code></td>
								<td data-reactid="1376"></td>
							</tr>
							<tr class="negative" data-reactid="1377">
								<td data-reactid="1379">5</td>
								<td data-reactid="1380">uint256</td>
								<td data-reactid="1381"><code data-reactid="1382">licenseExpiredAt</code></td>
								<td data-reactid="1383"></td>
							</tr>
							<tr class="negative" data-reactid="1384">
								<td data-reactid="1386">6</td>
								<td data-reactid="1387">uint256</td>
								<td data-reactid="1388"><code data-reactid="1389">disablingDate</code></td>
								<td data-reactid="1390"></td>
							</tr>
							<tr class="negative" data-reactid="1391">
								<td data-reactid="1393">7</td>
								<td data-reactid="1394">string</td>
								<td data-reactid="1395"><code data-reactid="1396">disablingTX</code></td>
								<td data-reactid="1397"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1398">
					<div class="ui right label ribbon" data-reactid="1399">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1402" style="margin-top:-1.5rem"><code data-reactid="1403">validators</code> <code class="signature" data-reactid="1405">35aa2e44</code></h3>
					<table class="ui definition table" data-reactid="1406">
						<tbody data-reactid="1407">
							<tr class="positive" data-reactid="1408">
								<td data-reactid="1409" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1410">0</td>
								<td data-reactid="1411">uint256</td>
								<td data-reactid="1412"></td>
								<td data-reactid="1413"></td>
							</tr>
							<tr class="negative" data-reactid="1414">
								<td data-reactid="1415" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1416">0</td>
								<td data-reactid="1417">address</td>
								<td data-reactid="1418"></td>
								<td data-reactid="1419"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1420">
					<div class="ui right label ribbon" data-reactid="1421">
						function
					</div>
					<h3 class="ui header" data-reactid="1423" style="margin-top:-1.5rem"><code data-reactid="1424">vote</code> <code class="signature" data-reactid="1426">c9d27afe</code></h3>
					<h4 data-reactid="1427"></h4>
					<p data-reactid="1428">Votes</p>
					<table class="ui definition table" data-reactid="1430">
						<tbody data-reactid="1431">
							<tr class="positive" data-reactid="1432">
								<td data-reactid="1433" rowspan="2" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1434">0</td>
								<td data-reactid="1435">uint256</td>
								<td data-reactid="1436"><code data-reactid="1437">ballotID</code></td>
								<td data-reactid="1438">
									<div data-reactid="1439">
										<p data-reactid="1440">Ballot unique ID</p>
									</div>
								</td>
							</tr>
							<tr class="positive" data-reactid="1442">
								<td data-reactid="1444">1</td>
								<td data-reactid="1445">bool</td>
								<td data-reactid="1446"><code data-reactid="1447">accept</code></td>
								<td data-reactid="1448">
									<div data-reactid="1449">
										<p data-reactid="1450">Vote for is true, vote against is false</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1452">
					<div class="ui right label ribbon" data-reactid="1453">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1456" style="margin-top:-1.5rem"><code data-reactid="1457">votingKeys</code> <code class="signature" data-reactid="1459">cbebcbbc</code></h3>
					<table class="ui definition table" data-reactid="1460">
						<tbody data-reactid="1461">
							<tr class="positive" data-reactid="1462">
								<td data-reactid="1463" rowspan="1" style="text-transform:capitalize">inputs</td>
								<td data-reactid="1464">0</td>
								<td data-reactid="1465">address</td>
								<td data-reactid="1466"></td>
								<td data-reactid="1467"></td>
							</tr>
							<tr class="negative" data-reactid="1468">
								<td data-reactid="1469" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1470">0</td>
								<td data-reactid="1471">bool</td>
								<td data-reactid="1472"><code data-reactid="1473">isActive</code></td>
								<td data-reactid="1474"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="ui segment" data-reactid="1475">
					<div class="ui right label ribbon" data-reactid="1476">
						function, constant
					</div>
					<h3 class="ui header" data-reactid="1479" style="margin-top:-1.5rem"><code data-reactid="1480">votingLowerLimit</code> <code class="signature" data-reactid="1482">f65fb8ab</code></h3>
					<table class="ui definition table" data-reactid="1483">
						<tbody data-reactid="1484">
							<tr class="negative" data-reactid="1485">
								<td data-reactid="1486" rowspan="1" style="text-transform:capitalize">outputs</td>
								<td data-reactid="1487">0</td>
								<td data-reactid="1488">uint256</td>
								<td data-reactid="1489"></td>
								<td data-reactid="1490"></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
