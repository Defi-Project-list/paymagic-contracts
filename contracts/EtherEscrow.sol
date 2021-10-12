pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import './interfaces/IWETHGateway.sol';

contract EtherEscrow {
    address arbiter;
    address depositor;
    address beneficiary;
    uint initialDeposit;
    IWETHGateway gateway = IWETHGateway(0xDcD33426BA191383f1c9B431A342498fdac73488);
    IERC20 aWETH = IERC20(0x030bA81f1c18d280636F32af80b9AAd02Cf0854e);
    
    // Aave referral code - currently unused
    uint16 referralCode = 0;
    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
        initialDeposit = msg.value;

        gateway.depositETH{value: address(this).balance}(address(this), referralCode);
    }

    receive() external payable {}

    function approve() external {
        require(msg.sender == arbiter);

        uint balance = aWETH.balanceOf(address(this));
        aWETH.approve(address(gateway), balance);

        gateway.withdrawETH(balance, address(this));
        payable(beneficiary).transfer(initialDeposit);
        payable(depositor).transfer(address(this).balance);
        // depositor get interest
    }
}

// TODO - Switch to WETHGateway V2; Move comments to README. 