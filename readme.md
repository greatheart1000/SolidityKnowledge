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

#### 荷兰拍卖
荷兰拍卖（`Dutch Auction`）是一种特殊的拍卖形式。 亦称“减价拍卖”，它是指拍卖标的的竞价由高到低依次递减直到第一个竞买人应价（达到或超过底价）时击槌成交的一种拍卖。<br>


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

```详细说明
 result := and(a, b) 
 输入的 a = 2 和 b = 4 来计算结果：
a = 2 (十进制) = 0b...00000010 (二进制，256 位)
b = 4 (十进制) = 0b...00000100 (二进制，256 位)
执行按位与 (AND) 操作：
 0b...00000010  (a = 2)
& 0b...00000100  (b = 4)
----------------
  0b...00000000  (结果 = 0)

contract ORExample {
    function bitwiseOr(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := or(a, b)
        }
        return result;
    }
}
1. or(a, b)  
   - 把 `a` 与 `b` 的二进制按位做 OR，任一位为 1，则结果该位为 1。  
   - 用途：合并掩码 (mask)，或把多个标志位打包在一个 word 里。  
如果你传入 a = 5 和 b = 3：
a = 5 (十进制) 在 256 位二进制中表示为 0...00000101
b = 3 (十进制) 在 256 位二进制中表示为 0...00000011
按位逻辑或（OR）操作的规则：
对于两个输入的对应位，如果任意一个位是 1，则结果位是 1。
只有当两个位都是 0 时，结果位才是 0。
a = 5  (0...00000101)
b = 3  (0...00000011)
--------------------
逐位 OR 操作：
最右边一位（第 0 位）：  1 OR 1 = 1
右数第二位（第 1 位）：  0 OR 1 = 1
右数第三位（第 2 位）：  1 OR 0 = 1
其余位（高位）：       0 OR 0 = 0
结果的二进制表示是 0...00000111
结果转换回十进制：
0...00000111 (二进制) 转换回十进制就是 4 + 2 + 1 = 7
最后，函数将 result（现在是一个十进制数）返回给你

2. xor(a, b)  
   - 按位异或：相同为 0，不同为 1。  
   - 用途：求两个值的差异位、简单加密/解密 (因其自逆特性)；也可用来打开/关闭某个位。
按位异或（XOR）操作的规则：
对于两个输入的对应位，如果两个位不同（一个是 0，一个是 1），则结果位是 1。
如果两个位相同（都是 0 或都是 1），则结果位是 0。
第一步：将十进制数转换为 256 位二进制表示（只展示相关低位）：

a = 5 (十进制) = 0b...00000101
b = 3 (十进制) = 0b...00000011
第二步：执行逐位 XOR 操作：

我们从最低位（最右边）开始比较 a 和 b 的对应位：
a 的位	b 的位	结果位 (a XOR b)	原因
1 (第0位)	1 (第0位)	0	相同 (1 和 1) -> 0
0 (第1位)	1 (第1位)	1	不同 (0 和 1) -> 1
1 (第2位)	0 (第2位)	1	不同 (1 和 0) -> 1
0 (第3位)	0 (第3位)	0	相同 (0 和 0) -> 0
...	...	...	(所有更高位都是 0 和 0，所以结果都是 0)
因此，a XOR b 的二进制结果是 0b...00000110。
第三步：将二进制结果转换回十进制：
0b...00000110 (二进制) = 4 + 2 + 0 = 6 (十进制)。
所以，当你调用 bitwiseXor(5, 3) 时，函数将返回 6

3. not(a)  
   - 对 256-bit 做位取反。  
   - 用途：快速生成掩码的反码，或求反操作。  
它对一个 256 位的二进制数 a 的所有位执行逻辑非操作。按位非（NOT）操作的规则：对于输入数值 a 的每一位：
如果该位是 0，则结果位是 1。
如果该位是 1，则结果位是 0。
简单来说，它将所有的 0 变为 1，所有的 1 变为 0。
重要注意事项：EVM 的 NOT 操作是针对整个 256 位字进行的。
在 EVM 里，uint256 恒定是 256 位二进制，not(a) 就是把这 256 位的每一位 0↔1 翻转一次。对于 a=5（也就是二进制……00000101），翻转后得到的就是全 1（2²⁵⁶−1）减去原来的 5，也就是：
 not(5) = (2²⁵⁶ − 1) − 5 = 2²⁵⁶ − 6
Remix 里默认用十六进制显示（长长的一串 0xffff…fffA，末尾的 A 就是十六进制的 10，对应十进制的 (2²⁵⁶−1 减 5)），同时也会帮你把它转换成一个十进制数：
115792089237316195423570985008687907853269984665640564039457584007913129639930
 
4. byte(pos, value)  
   - 从 `value` 的 32 字节（256 bit）表示中提取第 `pos` 个字节。  
   - EVM 里索引 `0` 表示最**高**字节（big-endian），`31` 表示最低字节；如果 `pos ≥ 32`，结果为 `0`。  
   - 用途：解包 bytes32、从 keccak 输出里取出某个字节、拼接小于 32 字节的数据。  
contract BYTEExample {
    function extractByte(uint256 position, uint256 value) public pure returns (uint8) {
        uint8 result;
        assembly {
            result := byte(position, value)
        }
        return result;
    }
}
byte(position, value) 是 EVM 汇编中的一个操作码，它的作用是从一个 256 位（32 字节）的 value 中提取位于 position 指定索引的单个字节
假设 value 是一个更长的十六进制数，例如一个 bytes32 哈希值：

value = 0xAABBCCDDEEFF00112233445566778899AABBCCDDEEFF00112233445566778899 (这是一个 32 字节的哈希值)
现在我们来提取不同 position 的字节：
extractByte(0, value): 将提取第一个字节 0xAA。
extractByte(1, value): 将提取第二个字节 0xBB。
extractByte(15, value): 将提取第十六个字节 0x88。
extractByte(31, value): 将提取最后一个字节 0x99
实际应用场景：
byte 操作码在以下场景中非常有用：
解析打包数据： 当一个 uint256 中存储了多个小于 32 字节的数据片段时（例如，将几个 uint8 或 uint16 打包到一个 uint256 中以节省存储空间），可以使用 byte 来提取这些小数据。
处理哈希值： 从哈希值（bytes32）中提取特定部分的字节，进行进一步的逻辑判断或处理。


5. shl(bits, value)  
   - 把 `value` 左移 `bits` 位，高位溢出被丢弃，低位补 `0`。  
   - 等价于 `value * 2**bits`（mod 2²⁵⁶）。  
   - 用途：把某个字段推到高位，或把小整数移到指定位置做打包。  
shl(bits, value) 是 EVM 汇编中的**逻辑左移（Shift Left Logical）**操作码。它的作用是将 value 的所有位向左移动 bits 指定的位数。在移动过程中，右侧空出的位将用零填充。
操作规则：
将 value 视为一个 256 位的二进制数。将这个二进制数的每一位向左移动 bits 指定的数量。最左边（最高位）被移出边界的位会被丢弃。右侧新空出的位将全部用 0 填充。
假设你调用 shiftLeft(value, bits) 函数，并传入以下值：
value = 5 (十进制)
bits = 3 (十进制，表示向左移动 3 位)
第一步：将 value 转换为 256 位二进制表示（只展示相关低位）：
value = 5 (十进制) = 0b...00000101
第二步：执行 shl(3, 0b...00000101) 操作：
我们将 0b...00000101 的所有位向左移动 3 位，并在右侧填充 3 个 0。
 ...00000101 --> ...00101000
将二进制结果转换回十进制：
0b...00101000 (二进制) = 2^5+2^3=32+8 =40 (十进制)
一个 1 在索引 3 处（2 3=8）。另一个 1 在索引 5 处（2 5=32）。所以结果是 8+32=40。

6. shr(bits, value)  
   - 逻辑右移：把 `value` 右移 `bits` 位，低位溢出被丢弃，高位补 `0`。  
   - 等价于 `floor(value / 2**bits)`.  
   - 用途：从高位字段抽取低位整数字段。  
function shiftRight(uint256 value, uint256 bits) public pure returns (uint256) {
        uint256 result; // 声明一个 uint256 类型的变量来存储结果
        assembly {
            // 这里是 EVM 汇编块
            // bits 和 value 这两个函数的参数会在进入 assembly 块之前被推到 EVM 堆栈上
            // shr(bits, value) 将执行逻辑右移操作
            result := shr(bits, value) // 执行逻辑右移，并将结果赋值给 result
        }
        return result; // 返回右移后的结果
    }
操作规则：
将 value 视为一个 256 位的二进制数。将这个二进制数的每一位向右移动 bits 指定的数量。最右边（最低位）被移出边界的位会被丢弃。左侧新空出的位将全部用 0 填充。
假设你调用 shiftRight(value, bits) 函数，并传入以下值：
value = 40 (十进制)
bits = 3 (十进制，表示向右移动 3 位)
第一步：将 value 转换为 256 位二进制表示（只展示相关低位）：
value = 40 (十进制) = 0b...00101000 (二进制)
第二步：执行 shr(3, 0b...00101000) 操作：
我们将 0b...00101000 的所有位向右移动 3 位，并在左侧填充 3 个 0。
 ...00101000 --> ...00000101  将二进制结果转换回十进制：
0b...00000101 (二进制) = 4+1=5 (十进制)
验证：shr 操作在智能合约开发中非常常用，尤其是在：
解包数据： 从一个 uint256 中提取之前打包进去的多个小的值。这与 shl 的打包功能相对应。
除法优化： 当需要除以 2^n 时，使用逻辑右移操作通常比实际的除法操作更省 Gas。


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
lessThan(5, 10) 5小于10  返回的结果是true
lt(a, b) (Less Than)： 将 a 和 b 视为无符号整数进行比较。例如，lt(0, -1) 会被视为 lt(0, 0xFF...FF)，结果为 true，因为 0 作为无符号数小于 0xFF...FF (2^256 - 1)。
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
gt(a, b) 在 Solidity 的 assembly 块中，就是用来比较 a 是否严格大于 b。
如果 a > b 为真，则返回 true (在 EVM 层面表现为 1)。
如果 a <= b 为假，则返回 false (在 EVM 层面表现为 0)
slt(a, b) 操作码会弹出堆栈顶部的两个值（对应于 b 和 a）。
它会比较 a 是否严格小于 b，考虑到它们的符号。
如果 a 小于 b，操作码会将 1（代表 true）推送到堆栈顶部。
如果 a 不小于 b（即 a >= b），操作码会将 0


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
与 lt (无符号小于) 的区别：
lt(a, b) (Less Than)： 将 a 和 b 视为无符号整数进行比较。例如，lt(0, -1) 会被视为 lt(0, 0xFF...FF)，结果为 true，因为 0 作为无符号数小于 0xFF...FF (2^256 - 1)。
slt(a, b) (Signed Less Than)： 将 a 和 b 视为有符号整数进行比较。例如，slt(0, -1) 会被视为 0 小于 -1 吗？结果为 false，因为 0 不小于 -1。



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
gt(a, b) 将 a 和 b 视为无符号整数（uint256 范围：0 到 2^256 −1）进行比较 
sgt(a, b) 将 a 和 b 视为有符号整数进行比较

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

32 字节（256 位）的数据”就是指 256 位的二进制数据
value 参数必须是一个 32 字节（256 位）的数据。这意味着无论你传入的是什么，它都会被扩展或截断成 256 位
function storeToMemory(uint256 offset, bytes32 value) public pure {
        assembly {
            mstore(offset, value)
        }
    }
实际应用场景：
mstore 是 EVM 内存管理的核心操作之一，在智能合约开发中非常重要，尤其是在：
处理可变长度数据： 例如，当你需要操作 bytes 或 string 类型的数据时，它们通常存储在内存中，并由 mstore 和 mload 等操作码进行读写。
构建函数调用数据： 在进行 CALL, DELEGATECALL 等操作之前，你需要将要发送的数据（如函数签名和参数编码）组装到内存中，然后通过 mstore 写入。
计算哈希： keccak256 操作码需要从内存中读取数据，所以你需要使用 mstore 将数据准备到内存中。

```
##### MLOAD，MSTORE，MSTORE8，MSIZE，MCLEAR，SLOAD，SSTORE 这几个EVM命令怎么理解和使用呢 请你解释一下
Memory (内存) vs. Storage (存储)
Memory (内存): 想象成你工作时的**“白板”或“草稿纸”**。
临时性： 你在白板上写的东西，一旦你下班（函数执行结束），白板就会被擦掉。下次你再来，白板是空的。 <br>
快速便宜： 在白板上写字非常快，用的笔墨（Gas）很少。  <br>
结构： 像一张大纸，你可以指定从哪里开始写（以字节为单位寻址），但你写的时候通常是一大块一大块地写（32 字节对齐）。 <br>
“懒惰清零”： 你不需要手动擦掉白板上的旧字。当你决定在某个区域写新字时，如果那里原来有旧字，EVM 会自动帮你清零，然后你再写入。你不用担心读取到脏数据。 <br>
Storage (存储): 想象成你写完文件后，把它**“存档”到公司的中央数据库或文件柜**。 <br>
永久性： 一旦你保存了，它就永远在那里（除非你明确删除或修改），不会因为你下班而消失。因为它被记录在区块链上。  <br>
昂贵缓慢： 存档（写入）或从存档中查找（读取）都比较慢，需要花费大量的精力和时间（Gas 费用非常高）。<br>
结构： 像一个巨大的键值对数据库，每个位置都有一个唯一的“槽号”（slot），你可以通过这个槽号来存取数据。<br>
