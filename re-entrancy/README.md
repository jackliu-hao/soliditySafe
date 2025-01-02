## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

# foundry的使用
https://github.com/AmazingAng/WTF-Solidity/blob/main/Topics/Tools/TOOL07_Foundry/readme.md

# Re-Entrancy-可重入攻击

## receive和fallback
Solidity支持两种特殊的回调函数，receive()和fallback()，他们主要在两种情况下被使用：

接收ETH
处理合约中不存在的函数调用（代理合约proxy contract）

### receive
receive()函数是在合约收到ETH转账时被调用的函数。一个合约最多有一个receive()函数，声明方式与一般函数不一样，不需要function关键字：`receive() external payable { ... }` 。receive()函数不能有任何的参数，不能返回任何值，必须包含external和payable。

当合约接收ETH的时候，receive()会被触发。receive()最好不要执行太多的逻辑因为如果别人用send和transfer方法发送ETH的话，gas会限制在2300，receive()太复杂可能会触发Out of Gas报错；如果用call就可以自定义gas执行更复杂的逻辑（这三种发送ETH的方法我们之后会讲到）。

### fallback
fallback()函数会在调用合约不存在的函数时被触发。可用于接收ETH，也可以用于代理合约proxy contract。fallback()声明时不需要function关键字，必须由external修饰，一般也会用payable修饰，用于接收ETH:`fallback() external payable { ... }`。

### receive和fallback的区别
```
触发fallback() 还是 receive()?
           接收ETH
              |
         msg.data是空？
            /  \
          是    否
          /      \
receive()存在?   fallback()
        / \
       是  否
      /     \
receive()   fallback()
```
单纯转账calldata为空，为了使得fallback的职责更加清晰，solidity安排了另一个特殊函数 receive() 来处理他。
## 发送ETH合约
https://github.com/AmazingAng/WTF-Solidity/tree/main/20_SendETH
### transfer
- 用法是接收方地址.transfer(发送ETH数额)。
- transfer()的gas限制是2300，足够用于转账，但对方合约的fallback()或receive()函数不能实现太复杂的逻辑。
- transfer()如果转账失败，会自动revert（回滚交易）。
### send
- 用法是接收方地址.send(发送ETH数额)。
- send()的gas限制是2300，足够用于转账，但对方合约的fallback()或receive()函数不能实现太复杂的逻辑。
- send()如果转账失败，不会revert。
- send()的返回值是bool，代表着转账成功或失败，需要额外代码处理一下。

### call
- 用法是接收方地址.call{value: 发送ETH数额}("")。
- call()没有gas限制，可以支持对方合约fallback()或receive()函数实现复杂逻辑。
- call()如果转账失败，不会revert。
- call()的返回值是(bool, bytes)，其中bool代表着转账成功或失败，需要额外代码处理一下。

## Anvil的使用
anvil 命令创建一个本地开发网节点（好像是对 hardhat node的封装 ），用于部署和测试智能合约。它也可以用来分叉其他与 EVM 兼容的网络。
https://learnblockchain.cn/docs/foundry/i18n/zh/anvil/index.html

## cast说明

### 账户相关
创建新的地址密钥对
https://learnblockchain.cn/docs/foundry/i18n/zh/reference/cast/cast-wallet-new.html



### 解析交易
cast 会从一个已经预设的 Ethereum Signature Database 中查找该函数选择器。这个数据库包含了许多标准智能合约和广泛使用的去中心化应用程序（DApp）中定义的函数签名和其选择器。像 [4byte.directory](https://www.4byte.directory/) 网站就是一个提供以太坊交易函数选择器数据库的开放资源，允许开发者查询选择器和相应的函数签名。
### 模拟交易
# Usage: cast run --rpc-url <URL> <TXHASH>

cast run 0x20e7dda515f04ea6a787f68689e27bcadbba914184da5336204f3f36771f59f0

后面跟着的是tx—hash
https://github.com/AmazingAng/WTF-Solidity/raw/main/Topics/Tools/TOOL07_Foundry/img/1.png

可以在结果中看到运行消耗的gas，以及方法顺序调用的过程，以及释放的emit的事件。通过这个可以了解一个hash的内在过程。

### 账户签名
两种方法都可以使用签名，第一种载入刚才生成的keystore私钥，第二种直接输入自己的私钥。
cast wallet sign <MESSAGE> --keystore=<PATH> 
cast wallet sign <MESSAGE> -i

## 调用合约
### 读合约数据
https://learnblockchain.cn/docs/foundry/i18n/zh/reference/cast/cast-call.html
cast call 用于从区块链上读取数据（调用只读函数），该操作不会改变区块链状态，也不需要支付 Gas 费用。

### 调合约（写数据）
https://learnblockchain.cn/docs/foundry/i18n/zh/reference/cast/cast-send.html

### 解码和合约交互的时候的数据
https://learnblockchain.cn/docs/foundry/i18n/zh/reference/cast/cast-calldata-decode.html
https://learnblockchain.cn/docs/foundry/i18n/zh/reference/cast/cast-pretty-calldata.html




## 参考链接
- https://www.wtf.academy/docs/solidity-104/S01_ReentrancyAttack/
- https://ctf-wiki.org/blockchain/ethereum/attacks/re-entrancy/

