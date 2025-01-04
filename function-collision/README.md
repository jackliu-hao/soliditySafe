# 选择器碰撞
## 函数选择器
https://github.com/AmazingAng/WTF-Solidity/blob/main/29_Selector/readme.md

可以用这两个网站来查同一个选择器对应的不同函数：
https://www.4byte.directory/

https://sig.eth.samczsun.com/

可以使用下面的Power Clash工具进行暴力破解：
https://github.com/AmazingAng/power-clash

## 解题思路
这个和ctfwiki中的function-selector有一些不同，这个是漏洞是function-collision 。需要碰撞出最终函数选择的结果

我们的目标是调用函数： putCurEpochConPubKeyBytes(bytes memory) ,得到他的select为：0x41973cd9 。 但是在函数executeCrossChainTx中将 参数_method 和 (bytes,bytes,uint64) 做个拼接，也就是如果想要调用 0x41973cd9 , 你需要让进行如下碰撞 xxx(bytes,bytes,uint64) 的keccak256的前四个字节是0x41973cd9 。 这里直接给出最终的结论：xxx应该是： f1121318093

但是因为executeCrossChainTx 的参数是bytes类型，因此需要把f1121318093转成hex传入。



# 参考文章
- wfk :https://www.wtf.academy/docs/solidity-104/S02_SelectorClash/#%E9%80%89%E6%8B%A9%E5%99%A8%E7%A2%B0%E6%92%9E
- https://rekt.news/zh/polynetwork-rekt/
