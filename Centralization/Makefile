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
	@forge install foundry-rs/forge-std

build:; forge build

deploy:
	@forge script script/DeployedMultisigWallet.s.sol:DeployMultisigWallet $(NETWORK_ARGS)

TARGET_ADDRESS := 0x5FbDB2315678afecb367f032d93F642f64180aa3

# 多签地址是 ACCOUNT1 和 ACCOUNT2
# 查询合约余额
getBalance:
	@BALANCE=$(shell cast call $(TARGET_ADDRESS) "getBalance()"   --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)) ;\
	echo "Balance (raw): $$BALANCE" ;\
	cast from-wei $$BALANCE

#1、向多签合约转10 ETH
send10ETHToContract:
	@cast send $(TARGET_ADDRESS) --value 10ether  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)


# 查看日志
# 从区块 1 到最新区块，查找 事件签名是 ReciveETH(address from,uint256 value) 的事件
getLogs:
	@cast logs --from-block 1 --to-block latest 'ReciveETH(address from,uint256 value)' --address $(TARGET_ADDRESS) --rpc-url $(LOCAL_RPC)

# 获取交易的hash值
getTxHash:
	@cast call  $(TARGET_ADDRESS)  "encodeTransactionData(address,uint256,bytes,uint256,uint256)"  $(ACCOUNT3) 5ether 0x01 0 31337 --private-key $(DEFAULT_ANVIL_KEY) --rpc-url=$(LOCAL_RPC)
# txHash: 0x8d43385c0507ed2d4839365296463d0479cafd939657888f241bf619079d03b5

# 获取多签地址对交易的hash的签名
#这一步暂时使用前端的钱包metaMask进行签名，因为我现在不会使用solidity进行签名,后面可以使用Go-ether签名
# 需要是钱包连接状态下
#1、ethereum.enable()
#account = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
#hash = "0x8d43385c0507ed2d4839365296463d0479cafd939657888f241bf619079d03b5"
#ethereum.request({method: "personal_sign", params: [account, hash]})
# 得到两个签名信息
#0x395cbae8aaabdaee04f0c93aa145dd2bb0abe4ad3fc4f5f5179e1c87d906e9875912597053a1cc951d98e347dabd8b9caadb2b4ca8af9dd463e0d7755f2ac8f41c

# 经过N小时的测试，还是用cast吧，气死了
# 这个就是多签认证中最终汇总
# SIGN2_NO_PREFIX=$$(echo $$SIGN2 | sed 's/^0x//'); 
singMsg:
	@SIGN1=$(shell cast wallet sign --private-key $(ACCOUNT2_PRIVATE) 0x8d43385c0507ed2d4839365296463d0479cafd939657888f241bf619079d03b5) ;\
	SIGN2=$$(cast wallet sign --private-key $(DEFAULT_ANVIL_KEY) 0x8d43385c0507ed2d4839365296463d0479cafd939657888f241bf619079d03b5 | sed 's/^0x//') ;\
	echo "$$SIGN1$$SIGN2"


MULTISIG := 0x395cbae8aaabdaee04f0c93aa145dd2bb0abe4ad3fc4f5f5179e1c87d906e9875912597053a1cc951d98e347dabd8b9caadb2b4ca8af9dd463e0d7755f2ac8f41c86c4c01f2338ebadef0e412509374355ff0c92e99fa6f5000013ccd4de0b8cb35e7b615ffb3acfc4c245785caf58f34d3363c3986a283c73e292368aff568b491c

# 使用execTransaction 向account3转账 5 ETH
send5ETHToAccount3:
	@cast send $(TARGET_ADDRESS) "execTransaction(address,uint256,bytes,bytes)" $(ACCOUNT3) 5ether 0x01 $(MULTISIG)   --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)


# sendEthFromMultiWallet2OthersSuecss:
# 1、先向合约转 10 元子,查看余额
# make send10ETHToContract
# make getBalance

# 注意这里的nonce每次调用都会+1

# 2、多签钱包向account3转5元子，但是需要，两个人同时对交易签名
#    2.1 使用 encodeTransactionData 对交易数据打包并计算哈希 得到TxA
#	 2.2 分别使用Ac1和Ac2对TxA进行签名
#    2.3 使用execTransaction 向Ac3转账
sendAc3:
	@TX_HASH=$(shell cast call  $(TARGET_ADDRESS)  "encodeTransactionData(address,uint256,bytes,uint256,uint256)"  $(ACCOUNT3) 5ether 0x01 1 31337 --private-key $(DEFAULT_ANVIL_KEY) --rpc-url=$(LOCAL_RPC)) ;\
	SIGN1=$$(cast wallet sign --private-key $(ACCOUNT2_PRIVATE) $$TX_HASH) ;\
	SIGN2=$$(cast wallet sign --private-key $(DEFAULT_ANVIL_KEY) $$TX_HASH | sed 's/^0x//') ;\
	MULTI_SIG=$$(echo "$$SIGN1$$SIGN2");\
	cast send $(TARGET_ADDRESS) "execTransaction(address,uint256,bytes,bytes)" $(ACCOUNT3) 5ether 0x01 $$MULTI_SIG   --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC) ;\
	
# 3、查看余额
# 4、 查看日志
getExecutionSuccessLog:
	@cast logs --from-block 1 --to-block latest 'ExecutionSuccess(bytes32)' --address $(TARGET_ADDRESS) --rpc-url $(LOCAL_RPC)



# 将十六进制转换成字符串
fromHex2String:
	@echo "Hexadecimal: $(hex)"
	@echo $(hex)  | xxd -r -p
	@echo ""   


# 将字符串转成十六进制
fromString2Hex:
	@echo "String: $(str)"
	@echo -n $(str) | xxd -p -c 256