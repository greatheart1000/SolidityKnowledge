#### solidity 学习知识点的链接 https://mp.weixin.qq.com/s/gOetk9Tqt7XMRpa5rWlnSw
create 和create2的区别是什么？ create 就是创建合约
contract Pair{
  address public getPairs;
  address public tokenA;
  address public tokenB;
  mapping(address=>mapping(address=>address))
}

contract createPair{
    Pair pair = new Pair(); //这就是create创建新合约  create 和create2的区别就是 create2可以预测合约的地址 
}

transfer和transferFrom 的区别 ？<br>
send、call和 transfer的区别? <br>

Legacy交易的结构包括以下字段： <br>
● nonce：发送方账户的交易序号  <br>
● gasPrice：每单位 gas 的价格  <br>
● gasLimit：交易消耗的最大 gas 量 <br>
● to：接收方地址 <br>
● value：转移的以太币数量 <br>
● data：交易的附加数据（可选） <br>
● v, r, s：交易的签名 <br>
