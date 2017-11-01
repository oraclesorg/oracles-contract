.PHONY: symlinks

DIR=$(shell pwd -P)

symlinks:
	if [ ! -e $(DIR)/node_modules/oracles-contract-validator ]; then ln -s $(DIR)/lib/oracles-contract-validator/src $(DIR)/node_modules/oracles-contract-validator; fi;
	if [ ! -e $(DIR)/node_modules/oracles-contract-key ]; then ln -s $(DIR)/lib/oracles-contract-key/src $(DIR)/node_modules/oracles-contract-key; fi;
	if [ ! -e $(DIR)/node_modules/oracles-contract-ballot ]; then ln -s $(DIR)/lib/oracles-contract-ballot/src $(DIR)/node_modules/oracles-contract-ballot; fi;

merge:
	node_modules/sol-merger/bin/sol-merger.js "src/*.sol" build
