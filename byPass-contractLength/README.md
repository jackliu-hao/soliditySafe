# 绕过合约长度检查

## extcodesize 
extcodesize 是 Solidity 中的一个低级函数，用于获取指定地址的合约字节码的大小。它的作用是帮助我们区分外部账户（EOA，Externally Owned Account）和智能合约地址。具体来说，extcodesize 可以用来判断一个地址是否为合约地址。

### extcodesize 作用说明
1. 获取字节码大小： extcodesize(address) 返回指定地址存储的字节码的长度（单位为字节）。如果该地址是一个外部账户（EOA），则字节码的大小为 0；如果该地址是一个智能合约地址，则返回大于 0 的字节码长度。

2. 区分外部账户（EOA）和合约地址：

EOA（Externally Owned Account）：一个普通用户账户，不能存储代码。extcodesize 对应的值为 0。
合约地址：存储智能合约的代码，extcodesize 返回大于 0 的值。

  很多 freemint 或者 airdrop 等项目希望防止程序员通过合约恶意铸造或领取免费的 NFT 或代币。利用 isContract 可以确保只有普通用户（EOA）能够调用某些合约函数，而合约无法调用，从而增强安全性。

### 注意事项

extcodesize 只能检查合约地址的字节码大小，不能完全保证调用者是外部账户。特别是在合约构造函数中，如果合约地址刚刚创建（还未有字节码），它的 extcodesize 可能仍然为 0。对此可以使用额外的判断（如 tx.origin）来增强安全性。
在某些情况下，攻击者可以通过中间代理合约绕过这种检查，所以这种方法并不绝对安全，尤其是当攻击者控制了调用者地址的情况下。





# 参考链接
- https://www.wtf.academy/docs/solidity-104/S08_ContractCheck/




