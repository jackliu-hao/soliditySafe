-include .env
# anvil的密钥
DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
ACCOUNT2_PRIVATE := 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
ACCOUNT3_PRIVATE := 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
ACCOUNT2 := 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
ACCOUNT1 := 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
ACCOUNT3 := 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC


anvil:; anvil  -m 'test test test test test test test test test test test junk' --steps-tracing  --block-time 10

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
LOCAL_RPC := http://localhost:8545
# 使用前需要先install
install:
	@forge install OpenZeppelin/openzeppelin-contracts --no-commit

build:; forge build


deploy:
	@forge script script/DeployedReplysign.s.sol:DeploySigReplay $(NETWORK_ARGS)

TARGET_ADDRESS := 0x5FbDB2315678afecb367f032d93F642f64180aa3

# 线下签名，使用代码
getSignBySol:
	@MSG_HASH1=$(shell cast call  $(TARGET_ADDRESS)  "getMessageHash(address,uint256)"  $(ACCOUNT3) 5ether --private-key $(DEFAULT_ANVIL_KEY) --rpc-url=$(LOCAL_RPC)) ;\
	MSG_HASH=$$(cast call  $(DEFAULT_ANVIL_KEY)  "toEthSignedMessageHash(bytes32)"  $$MSG_HASH1) ;\
	SIGN=$$(cast wallet sign --private-key $(ACCOUNT2_PRIVATE) $$MSG_HASH) ;\
	echo "$$SIGN"

# 线下签名，使用钱包
getSign:
	@MSG_HASH=$(shell cast call  $(TARGET_ADDRESS)  "getMessageHash(address,uint256)"  $(ACCOUNT3) 5ether --private-key $(DEFAULT_ANVIL_KEY) --rpc-url=$(LOCAL_RPC)) ;\
	SIGN=$$(cast wallet sign --private-key $(DEFAULT_ANVIL_KEY) $$MSG_HASH) ;\
	echo "$$SIGN"
# 0x741afefc59d54a7abdedf283ac5daa1f260fe09ea31c74d7a2ece2d32fe87be63411285211a4ec5dfc340a664db308212a67af2171d787c5076aecc798b236271b

SIGN := 0x1cfeee5c1d2ad5eed88070e545b6ba18518dec0f7ce40b395f6c91a0a5cf4a2a65ca0035adcfaf44a30b9abcc3bb1c4db43203aff3d2a96b8b8315ab277e1e1a1c
# 线上交易和验证阶段
sendAndverifySignVul:
	@ cast send  $(TARGET_ADDRESS)  "badMint(address,uint,bytes)"  $(ACCOUNT3) 5ether $(SIGN) --private-key $(DEFAULT_ANVIL_KEY) --rpc-url=$(LOCAL_RPC)
sendAndverifySignFix:
	@ cast send  $(TARGET_ADDRESS)  "goodMint(address,uint,bytes)"  $(ACCOUNT3) 5ether $(SIGN) --private-key $(DEFAULT_ANVIL_KEY) --rpc-url=$(LOCAL_RPC)



# 获取账户余额
getBalance:
	@BALANCE=$(shell cast call  $(TARGET_ADDRESS)  "balanceOf(address)"  $(ACCOUNT3) --private-key $(DEFAULT_ANVIL_KEY) --rpc-url=$(LOCAL_RPC)) ;\
	echo "Balance (raw): $$BALANCE" ;\
	cast from-wei $$BALANCE
