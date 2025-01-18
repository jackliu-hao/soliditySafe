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
	@forge install foundry-rs/forge-std --no-commit
	@forge install OpenZeppelin/openzeppelin-contracts --no-commit



build:; forge build


deploy:
	@forge script script/DeployedContract.s.sol:DeployedContract $(NETWORK_ARGS)

# 攻击合约地址
ATTACK_ADDRESS := 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
# 合约地址
CONTRACT_ADDRESS := 0x5FbDB2315678afecb367f032d93F642f64180aa3

# 使用普通账户调用minit方法 ，（是可以的）
minitByAccount:
	@cast send $(CONTRACT_ADDRESS) "mint()" --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)


# 使用合约账户调用minit方法，（理论不可行，会报错）
minitByContract:
	@cast send $(ATTACK_ADDRESS) "mint()" --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)


# 使用合约账户中的构造函数调用 minit方法， （绕过了合约检查）
# 再创建部署的时候已经完成调用

# 查询普通账户余额
getBalanceByAccount:
	@cast call $(CONTRACT_ADDRESS) "balanceOf(address)" $(ACCOUNT2) --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

# 查询合约账户余额
getBalanceByContract:
	@cast call $(CONTRACT_ADDRESS) "balanceOf(address)" $(ATTACK_ADDRESS) --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)
