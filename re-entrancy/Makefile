-include .env


# anvil的密钥
DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
ACCOUNT2_PRIVATE := 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
ACCOUNT2 := 0x70997970C51812dc3A010C7d01b50e0d17dc79C8

# 部署的时候的参数
NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
LOCAL_RPC := http://localhost:8545

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network Arbitrum\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make fund ARGS=\"--network Arbitrum\""


# anvil :; 定义了一个名为 anvil 的目标。冒号 : 后面的分号 ; 表示在同一行执行命令。
# --block-time 10  加上这个参数就是 每10秒出一个区块
anvil :; anvil  -m 'test test test test test test test test test test test junk' --steps-tracing  --block-time 10

build:; forge build

ifeq ($(findstring --network Arbitrum,$(ARGS)),--network Arbitrum)
	NETWORK_ARGS := --rpc-url $(Arbitrum_RPC_RUL) --private-key $(PRIVATE_KEY) --broadcast 
endif

deploy:
	@forge script script/DeployBank.s.sol:DeployBank $(NETWORK_ARGS)

# cast 交互部分操作============
# 查询区块信息 ， 需要替换 区块 部分 
getBlockinfo:
	@cast block 3 --json

# 交易相关 =====

# 查询交易 
getTxInfo:
	@cast tx 0xadf3ad081ea4ac982036940a0b0a4f7811dc5b3a6ea0e8a72912d19b1995cd6a
# 或者 ，但是 receipt 能看到合约代码中输出的log  cast receipt 0x20e7dda515f04ea6a787f68689e27bcadbba914184da5336204f3f36771f59f0 

#交易解析 , 其实就是通过function selector 拿到函数
getFunctionBySelector:
# cast 解析交易见readMe笔记部分
	@cast 4byte 0x38ed1739
# 交易签名
getFunctionSelectorByName:
	@cast sig "swapExactTokensForTokens(uint256,uint256,address[],address,uint256)"

# 交易解码, 可以通过该方法decode交易的数据，类似etherscan中的decode方法
#  先获取input数据，然后进行解码

getCalldataByTx:
# 打印calldata（可选，用于调试）
	CALL_DATA := $(shell cast tx 0xadf3ad081ea4ac982036940a0b0a4f7811dc5b3a6ea0e8a72912d19b1995cd6a input)
	@echo "calldata: $(CALL_DATA)"
# 使用存储的input数据进行pretty-calldata解析
	@cast pretty-calldata $(CALL_DATA)

#模拟运行 , 见readMe详解
castRun:
# Usage: cast run --rpc-url <URL> <TXHASH>
	@cast run 0xadf3ad081ea4ac982036940a0b0a4f7811dc5b3a6ea0e8a72912d19b1995cd6a

#=======账户管理=====
# 创建账户
newAccount:
	@cast wallet new
# 账户签名,见readMe
signByAccount:
	@cast wallet sign <MESSAGE> -i $(DEFAULT_ANVIL_KEY)

# 账户验证
verifyAccountSign:
	@cast wallet verify --address <ADDRESS> <MESSAGE> <SIGNATURE> 

# ========== 合约交互 ==============

CONTRACT_ADDRESS := 0x5FbDB2315678afecb367f032d93F642f64180aa3
# 获取合约
getContract:
# 需要替换合约地址 0x5FbDB2315678afecb367f032d93F642f64180aa3
# cast etherscan-source 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 --etherscan-api-key='key'
	@cast etherscan-source  $(CONTRACT_ADDRESS)

#调用合约(读数据),重要见readMe
getContractBalance:
	@BALANCE=$(shell cast call $(CONTRACT_ADDRESS) "getBalance()"  --rpc-url=$(LOCAL_RPC));\
	echo "Balance (raw): $$BALANCE" ;\
	cast from-wei $$BALANCE
	

#调用合约(写数据)，存钱 100ETH ,指定使用账户ACCOUNT2_PRIVATE
deposit:
	@cast send $(CONTRACT_ADDRESS) "deposit()" --value 100ether --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC) 

# 拿到自己的余额
getMyBalance:
	@cast call $(CONTRACT_ADDRESS) "getUserBalance()"  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

getMyAllBalance:
	@cast call $(CONTRACT_ADDRESS) "getAllBalance()"  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

# 取钱
withdraw:
	@cast send $(CONTRACT_ADDRESS) "withdraw()"  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

# 把十进制转成对应类型的值
# 'to-int256', 'to-bytes32', 't', 'to-utf8', 'to-unit', 'to-wei', 'to-dec', 'to-hexdata', 'to-hex'
# from-wei 
fromHexToEth:
	cast from-wei 0x000000000000000000000000000000000000000000000001158e460913d00000
# 调用合约的时候会返回一些hex数据，其实是ABI标准编码
prettyCalldata:
	@cast pretty-calldata  0x08c379a000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000014496e73756666696369656e742062616c616e6365000000000000000000000000

# Eval合约交互
EVAL_ADDRESS := 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
ACCOUNT3 := 0x993Ce570f0d586aBB16Ed4644B759028d8Bb2349
ACCOUNT3_PRIVATE := 0xc2bf94d3308f7c223c0f8d71429d6cd61fb98a8139f2dfa8bb22c2d778f06111

getEvalBalance:
	@cast call $(EVAL_ADDRESS) "getBanlance()"  --private-key $(ACCOUNT3_PRIVATE) --rpc-url=$(LOCAL_RPC)

attack:
	@cast send $(EVAL_ADDRESS) "attack()" --value 1ether  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

getEvalBalanceInbank:
	@BALANCE=$(shell cast call $(EVAL_ADDRESS) "getBanlance()"  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC));\
	echo "Balance (raw): $$BALANCE" ;\
	cast from-wei $$BALANCE

#  攻击测试过程
# 1、查看Bank合约余额 （初始为0） make getContractBalance
# 2、使用账户2想合约存入100ETH    make deposit 
# 3、查看Bank合约余额 （100ETH）  make getContractBalance
# 4、查看Eval合约在Bank合约中的余额 （初始为0） make getEvalBalanceInbank
# 5、调用Eval合约中的attack函数 make attack
# 6、查看Bank合约余额 （0） make getContractBalance
# 7、查看Eval合约余额 （101Eth） make getEvalBalanceInbank 
# 攻击成功 
