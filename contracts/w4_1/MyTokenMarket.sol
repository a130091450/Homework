//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//* 编写合约 MyTokenMarket 实现：
//* AddLiquidity():函数内部调用 UniswapV2Router 添加 MyToken 与 ETH 的流动性
//* buyToken()：用户可调用该函数实现购买 MyToken

interface UniswapV2Router02 {
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);

}


contract MyTokenMarket {
    address myToken;
    address router;
    address WETH;

    constructor (address _myToken, address _WETH) {
        myToken = _myToken;
        WETH = _WETH;
    }

    function addLiquidity(uint _amountTokenDesired, uint _amountTokenMin, uint _amountETHMin) payable external {
        // 调用者向此合约转账
        uint256 amountTokenDesired = _amountTokenDesired;
        uint256 amountETHDesired = msg.value;
        IERC20.transferFrom(msg.sender, address(this), amountTokenDesired);

        // IERC20授权，让router可以转账该合约的token
        IERC20.approve(router, amountTokenDesired);

        // 跨合约调添加流动性
        bytes4 selector = bytes4(keccak256(bytes('addLiquidityETH(address,uint256,uint256,uint256,address,uint256)')));
        (bool success, bytes memory data) = router.call{value : amountETHDesired}(abi.encodeWithSelector(
                selector,
                myToken,
                amountETHDesired,
                _amountTokenMin,
                _amountETHMin,
                msg.sender,
                block.timestamp + 5 minutes
            ));
        require(success, "add liquidity fail!");
        uint256 amountETH = abi.decode(data,(uint256));
        uint256 amountToken = abi.decode(data,(uint256));

        // 多的钱返回给msg.sender
        address(this).transfer(msg.sender, amountETHDesired - amountETH);
        IERC20.transfer(msg.sender, amountTokenDesired - amountToken);
    }

    function buyToken() external {
        uint256[] path = new uint256[](2);
        // 计算out amount
        path[0] = WETH;
        path[1] = myToken;
        // 调用router
        UniswapV2Router02(router).swapETHForExactTokens(type(uint256).max, path, msg.sender, block.timestamp + 5 minutes);
    }
}
