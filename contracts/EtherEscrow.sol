pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";

interface IWETHGateway {
  function depositETH(address onBehalfOf, uint16 referralCode) external payable;
  function withdrawETH(uint256 amount, address to) external;
}

contract EtherEscrow {
  address arbiter;
  address depositor;
  address beneficiary;
  uint initialDeposit;
  IWETHGateway gateway = IWETHGateway(0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70);
  IERC20 aWETH = IERC20(0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347);

  constructor(address _arb, address _ben) payable {
    arbiter = _arb;
    beneficiary = _ben;
    initialDeposit = msg.value;
    depositor = msg.sender;
    gateway.depositETH{value: address(this).balance}(address(this), 0);
  }

  receive() external payable {}

  function withdraw() external {
    uint balance = aWETH.balanceOf(address(this));
    aWETH.approve(address(gateway), balance);

    gateway.withdrawETH(balance, address(this));

    payable(beneficiary).transfer(initialDeposit);
    selfdestruct(payable(depositor));
  }
}