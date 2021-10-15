// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./MerkleDistributor.sol";

contract AirdropFactory {
  struct AirdropData {
    address addr;
    string cid;
  }

  mapping(uint256 => AirdropData) public deployedAirdops;
  uint256 public airdropCount = 0;

  event AirdropCreated(address indexed addr, uint256 id);

  function getAirdropAddress(uint256 _id) external view returns (address) {
    return deployedAirdops[_id].addr;
  }

  function getAirdropCID(uint256 _id) external view returns (string memory) {
    return deployedAirdops[_id].cid;
  }

  function createAirdrop(
    address _token,
    bytes32 _merkleRoot,
    string memory _cid
  ) external {
    require(
      deployedAirdops[airdropCount].addr ==
        0x0000000000000000000000000000000000000000
    );
    address airdropAddress = address(
      new MerkleDistributor(_token, _merkleRoot)
    );
    deployedAirdops[airdropCount] = AirdropData(airdropAddress, _cid);
    emit AirdropCreated(airdropAddress, airdropCount);
    airdropCount++;
  }
}
