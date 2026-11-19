# Carga las variables desde .env si existe (el guion evita error si falta).
-include .env
export

.PHONY: build test deploy

build:
	forge build

test:
	forge test

# Despliega en Sepolia y verifica en Etherscan. Requiere SEPOLIA_RPC_URL, ETHERSCAN_API_KEY y PRIVATE_KEY en .env.
deploy:
	forge script script/Deploy.s.sol:DeployScript --rpc-url $(SEPOLIA_RPC_URL) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
