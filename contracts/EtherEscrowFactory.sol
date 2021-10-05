pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Create2.sol";
import "./EtherEscrow.sol";

contract EtherEscrowFactory{

  mapping (address => address) public escrowForAddress;


  event EtherEscrowDeployed(
    address indexed beneficiary,
    address indexed arbiter
  );

  function deployEtherEscrow(
    address arbiter,
    address beneficiary,
    bytes32 salt
  ) public payable returns (address escrowAddress){
    require(escrowForAddress[beneficiary] == address(0), "User is already in escrow");

    bytes memory bytecode = abi.encodePacked(
      type(EtherEscrow).creationCode,
      abi.encode(
        arbiter,
        beneficiary
      )
    );

    escrowAddress = Create2.deploy(0, salt, bytecode);

    escrowForAddress[beneficiary] = escrowAddress;
    
    EtherEscrow escrow = EtherEscrow(payable(escrowAddress));

    escrow.initialize(arbiter, beneficiary);

    emit EtherEscrowDeployed(
      beneficiary,
      arbiter
    );

    return escrowAddress;
  }
}