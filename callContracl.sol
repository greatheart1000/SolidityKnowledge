// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
//一个合约对另一个合约的引用 
contract demoContract{
    uint256 private X=0;
    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);

    function getBalance() view public returns(uint256){
        return address(this).balance;
    }
    // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 x) external payable{
        X =x;
        // 如果转入ETH，则释放Log事件
        if (msg.value>0){
            emit Log(msg.value,gasleft());

        }
    }
    // 读取x
    function getX() external view returns(uint256 x){
        x =X;
    }

}
//一个合约引用另外一个合约 

contract anotherContract{
    function callsetX(address to, uint256 x) external {
        demoContract(to).setX(x);
    }//为什么调用另外一个合约 可以传入地址呢 

    function callGetX(demoContract _address) external view returns(uint256 x){
        x =_address.getX();
    }

    function setXTransferEth(address addr, uint256 x) payable  external  {
        demoContract(addr).setX{value:msg.value}(x);
    }
}
