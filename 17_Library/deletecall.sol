// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Pair{
    address public factory; // 工厂合约地址
    address public token0; // 代币1
    address public token1; // 代币2
    constructor() payable {
        factory = msg.sender;
    }
    // called once by the factory at time of deployment
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }
}

contract Factory{
    mapping (address => mapping (address => address) ) public getpair;
    // 通过两个代币地址查Pair地址
    address[] public allpairs; // 保存所有Pair地址
    function createPairs(address tokenA, address tokenB) external 
    returns(address pairAddr) {
        //创建新合约
        Pair pair =new Pair() ;
        pair.initialize(tokenA,tokenB);
        //更新地址
        pairAddr = address(pair);
        allpairs.push(pairAddr);
        getpair[tokenA][tokenB] =pairAddr;
        getpair[tokenB][tokenA] =pairAddr;
    }


}