.PHONY: symlinks

symlinks:
	ln -fs $(shell pwd -P)/lib/oracles-contract-validator/src $(shell pwd -P)/node_modules/oracles-contract-validator
	ln -fs $(shell pwd -P)/lib/oracles-contract-key/src $(shell pwd -P)/node_modules/oracles-contract-key
	ln -fs $(shell pwd -P)/lib/oracles-contract-ballot/src $(shell pwd -P)/node_modules/oracles-contract-ballot

merge:
	node_modules/sol-merger/bin/sol-merger.js "src/*.sol" build
