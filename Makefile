-include .env

build:; forge build

deploy-sepolia:
	forge script script/DeployVendingMachine.s.sol:DeployVendingMachine --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY_SEPOLIA) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_URL) -vvvv
