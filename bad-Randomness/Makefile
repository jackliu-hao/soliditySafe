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

RANDOM_ADDRESS := 0x5FbDB2315678afecb367f032d93F642f64180aa3
BAD_ADDRESS := 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
ATTACK_ADDRESS := 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0

deploy:
	@forge script script/DeployedRandom.s.sol:DeployedRandom $(NETWORK_ARGS)

getChainRandom:
	@cast call $(RANDOM_ADDRESS) "getRandomOnchain()"   --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

# 获取 余额数量
getBanlance:
	@cast call $(BAD_ADDRESS) "balanceOf(address)" $(ATTACK_ADDRESS)   --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)

# 根据tokenId获取所有者
getOwnerByTokenId:
	@cast call $(BAD_ADDRESS) "ownerOf(uint)" 0x01   --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)


# 正常用户抽奖
normalLuckyMint:
	@cast send $(BAD_ADDRESS) "luckyMint(uint256)" 0x123456  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)


# attack攻击
attack:
	@cast send $(ATTACK_ADDRESS) "attackMint(address)" $(BAD_ADDRESS)  --private-key $(ACCOUNT2_PRIVATE) --rpc-url=$(LOCAL_RPC)



# 将十六进制转换成字符串
fromHex2String:
	@echo "Hexadecimal: $(hex)"
	@echo $(hex)  | xxd -r -p
	@echo ""   

