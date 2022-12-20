// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FlashLoanSimpleReceiverBase} from '@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol';
import {IPoolAddressesProvider} from '@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPool} from '@aave/core-v3/contracts/interfaces/IPool.sol';

contract flashloan is FlashLoanSimpleReceiverBase{
  address owner;
  constructor(address _addressprovider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider( _addressprovider)){
    
    owner=msg.sender;
  }
   function executeOperation(
    address asset,
    uint256 amount,
    uint256 premium,
    address initiator,
    bytes calldata params
  ) external override returns (bool){
    uint256 totalamount=amount+premium;
    IERC20(asset).approve(address(POOL),totalamount);
    return true;
  }
function requestflashloan(address _token,uint256 _amount)public{
    address receiverAddress=address(this);
    address asset=_token;
    uint256 amount=_amount;
    bytes memory params=" ";
    uint16 referralCode=0;
  POOL.flashLoanSimple(
    receiverAddress,
     asset,
     amount,
     params,
     referralCode
  ) ;


}
 receive() external payable {
        // React to receiving ether
    }
   
    function withdraw()  public payable onlyowner{
         payable(msg.sender).transfer(address(this).balance);
    }


modifier onlyowner {
  require(msg.sender==owner,"dont try to steal my ether");
  _;
}
}
