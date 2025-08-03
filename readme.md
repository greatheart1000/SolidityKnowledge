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

#### EIP 全称 `Ethereum Improvement Proposals`(以太坊改进建议)  <br>
是以太坊开发者社区提出的改进建议, 是一系列以编号排定的文件, 类似互联网上IETF的RFC。`EIP`可以是 `Ethereum` 生态中任意领域的改进, 比如新特性、ERC、协议改进、编程工具等等。 <br>

#### ERC`全称 Ethereum Request For Comment (以太坊意见征求稿) <br>
用以记录以太坊上应用级的各种开发标准和协议。如典型的Token标准(`ERC20`, `ERC721`)、名字注册(`ERC26`, `ERC13`), URI范式(`ERC67`), Library/Package格式(`EIP82`), 钱包格式 <br>(`EIP75`,`EIP85`)。
ERC协议标准是影响以太坊发展的重要因素, 像`ERC20`, `ERC223`, `ERC721`, `ERC777`等, 都是对以太坊生态产生了很大影响。 
所以最终结论：`EIP`包含`ERC`。 <br>
ERC165就是检查一个智能合约是不是支持了`ERC721`，`ERC1155`的接口。 <br>
`IERC721`是`ERC721`标准的接口合约，规定了`ERC721`要实现的基本函数。 <br>
它利用`tokenId`来表示特定的非同质化代币，授权或转账都要明确`tokenId`；而`ERC20`只需要明确转账的数额即可。<br>

#### Facet代币水龙头合约
代币水龙头就是让用户免费领代币的网站/应用 <br>
实现一个简版的`ERC20`水龙头，逻辑非常简单：我们将一些`ERC20`代币转到水龙头合约里，用户可以通过合约的`requestToken()`函数来领取`100`单位的代币，每个地址只能领一次 <br>
们在水龙头合约中定义3个状态变量
- `amountAllowed`设定每次能领取代币数量（默认为`100`，不是一百枚，因为代币有小数位数）。
- `tokenContract`记录发放的`ERC20`代币合约地址。
- `requestedAddress`记录领取过代币的地址。
首先用ERC20生成ERC20 token合约，然后得到ERC20合约地址，将其mint 10000枚token, 然后切换到facet.sol合约 填进ERC20合约地址，然后到ERC20合约的transfer函数填facet合约地址，转移<br>
ERC20的token；然后换一个地址，调用requestToken 这个新地址就得到了amount数量的token  requestedAddress查看新地址有没有领取过facet token <br>

#### Airdrop空投
`Airdrop`空投合约逻辑非常简单：利用循环，一笔交易将`ERC20`代币发送给多个地址 <br>
我首先部署ERC20合约 然后铸造了1000-枚token 然后初始化airdrop合约得到其合约地址，然后在ERC20合约的approve了airdrop合约地址1000枚token，
再使用airdrop的multiTransferToken报错了  <br>
理解了 token地址填错了 虽然我授权airdrop地址token了 但是转账ERC20 token仍然走的是原来的ERC20合约地址 而不是airdrop合约地址  <br>
但是 好像 transferETH和其他的函数getSum是有问题的  <br>

在 Solidity 的内联 Yul/assembly 里，这几个指令都是对 EVM 256-bit 字（word）做位运算或位操作，它们直接对应底层的 EVM opcode，通常比高层 Solidity 运算更**节省 gas**，也更灵活地做**打包/解包**、**掩码**、**位段提取**等操作。

下面一一说明它们的作用、参数含义和典型用途：

| 指令   | 作用                                    | 参数                            | 例子                                                 |
|------|---------------------------------------|-------------------------------|----------------------------------------------------|
| or   | 位或（bitwise OR）                       | a, b  — 两个 256-bit 值             | `or(0x01, 0x02) → 0x03`                            |
| xor  | 位异或（bitwise XOR）                     | a, b                            | `xor(0x03, 0x01) → 0x02`                           |
| not  | 位非（bitwise NOT）                       | a                               | `not(0x00FF) → 0x...FF00`(256-bit 取反)              |
| byte | 提取某个字节                                | position (0–31), value         | `byte(0, 0x1234...) → 0x12`<br>`byte(31, 0x1234...) → 0x34` |
| shl  | 左移（logical shift left）                | bits, value                    | `shl(8, 0x01) → 0x0100`                          |
| shr  | 逻辑右移（logical shift right，左补零）      | bits, value                    | `shr(8, 0x0100) → 0x01`                           |
| sar  | 算术右移（arithmetic shift right，符号扩展） | bits, value                    | `sar(8, 0xFF00…00) → 0xFFFF…FF`（如果最高位为 1，保持符号） |

---

## 详细说明

1. or(a, b)  
   - 把 `a` 与 `b` 的二进制按位做 OR，任一位为 1，则结果该位为 1。  
   - 用途：合并掩码 (mask)，或把多个标志位打包在一个 word 里。  
   
2. xor(a, b)  
   - 按位异或：相同为 0，不同为 1。  
   - 用途：求两个值的差异位、简单加密/解密 (因其自逆特性)；也可用来打开/关闭某个位。  
   
3. not(a)  
   - 对 256-bit 做位取反。  
   - 用途：快速生成掩码的反码，或求反操作。  
   
4. byte(pos, value)  
   - 从 `value` 的 32 字节（256 bit）表示中提取第 `pos` 个字节。  
   - EVM 里索引 `0` 表示最**高**字节（big-endian），`31` 表示最低字节；如果 `pos ≥ 32`，结果为 `0`。  
   - 用途：解包 bytes32、从 keccak 输出里取出某个字节、拼接小于 32 字节的数据。  
   
5. shl(bits, value)  
   - 把 `value` 左移 `bits` 位，高位溢出被丢弃，低位补 `0`。  
   - 等价于 `value * 2**bits`（mod 2²⁵⁶）。  
   - 用途：把某个字段推到高位，或把小整数移到指定位置做打包。  
   
6. shr(bits, value)  
   - 逻辑右移：把 `value` 右移 `bits` 位，低位溢出被丢弃，高位补 `0`。  
   - 等价于 `floor(value / 2**bits)`.  
   - 用途：从高位字段抽取低位整数字段。  
   
7. sar(bits, value)  
   - 算术右移：类似 `shr`，但高位补 `value` 的**符号位**（最高位），保持带符号整数的正负。  
   - 用途：带符号固定宽度整数的除以 2ⁿ，或实现有符号数的位段提取。  

---

## 典型场景示例

```solidity
function packUint16(uint16 a, uint16 b) external pure returns (bytes32 result) {
    assembly {
        // 把 a 放在高 16 位，把 b 放在低 16 位，其他位清零
        result := or(shl(240, a), b)
        // 240 = (32-2)*8
    }
}

function unpackUint16(bytes32 v) external pure returns (uint16 a, uint16 b) {
    assembly {
        a := shr(240, v)        // 右移 240 位，取出高 16 位
        b := and(v, 0xFFFF)     // 低 16 位做掩码
    }
}
```

- `packUint16`：将两个 16 bit 值打包到一个 256 bit 中；  
- `unpackUint16`：把打包结果再拆出来。  

通过这些位运算指令，你可以非常高效地做各种**打包/解包**、**掩码**、**位段提取**、**简易加解密**等操作。


```
EVM 比较指令集
在以太坊虚拟机（EVM）中，比较运算符用于比较堆栈上的数值，并返回布尔结果（0 或 1）。以下是详细介绍 EVM 中的比较运算符指令，包括 LT、GT、SLT、SGT、EQ 和 ISZERO。
1.小于指令 LT
● 操作码: 0x10
● 功能: 比较堆栈顶端的第二个数值是否小于堆栈顶端的第一个数值。如果是，将 1 推送到堆栈顶端；否则，推送 0。
● 气体费用: 3 gas
● 示例:
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LTExample {
    function lessThan(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := lt(a, b)
        }
        return result;
    }
}
2.大于指令 GT
● 操作码: 0x11
● 功能: 比较堆栈顶端的第二个数值是否大于堆栈顶端的第一个数值。如果是，将 1 推送到堆栈顶端；否则，推送 0。
● 气体费用: 3 gas
● 示例:
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GTExample {
    function greaterThan(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := gt(a, b)
        }
        return result;
    }
}
3.有符号小于指令 SLT
● 操作码: 0x12
● 功能: 进行有符号整数比较，检查堆栈顶端的第二个数值是否小于堆栈顶端的第一个数值。如果是，将 1 推送到堆栈顶端；否则，推送 0。
● 气体费用: 3 gas
● 示例:
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SLTExample {
    function signedLessThan(int256 a, int256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := slt(a, b)
        }
        return result;
    }
}
6.有符号大于指令 SGT
● 操作码: 0x13
● 功能: 进行有符号整数比较，检查堆栈顶端的第二个数值是否大于堆栈顶端的第一个数值。如果是，将 1 推送到堆栈顶端；否则，推送 0。
● 气体费用: 3 gas
● 示例:
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SGTExample {
    function signedGreaterThan(int256 a, int256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := sgt(a, b)
        }
        return result;
    }
}
7.等于指令 EQ
● 操作码: 0x14
● 功能: 比较堆栈顶端的两个数值是否相等。如果相等，将 1 推送到堆栈顶端；否则，推送 0。
● 气体费用: 3 gas
● 示例:
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EQExample {
    function equal(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := eq(a, b)
        }
        return result;
    }
}
8.是否为零指令 ISZERO
● 操作码: 0x15
● 功能: 检查堆栈顶端的数值是否为零。如果是，将 1 推送到堆栈顶端；否则，推送 0。
● 气体费用: 3 gas
● 示例:
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ISZEROExample {
    function isZero(uint256 a) public pure returns (bool) {
        bool result;
        assembly {
            result := iszero(a)
        }
        return result;
    }
}
```
