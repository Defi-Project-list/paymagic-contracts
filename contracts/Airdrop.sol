pragma solidity ^0.8.0;

import "./MerkleDistributor.sol";

contract Airdrop {
    struct AirdropData {
        address addr;
    }

    mapping(uint256 => AirdropData) public airdrops;
    uint256 public count = 0;

    event AirdropCreated(address indexed addr, uint256 id);

    function getAirdropAddress(uint256 _id) external view returns (address) {
        return airdrops[_id].addr;
    }

    function addAirdrop(
        address _token,
        bytes32 _merkleRoot
    ) external {
        require(
            airdrops[count].addr == 0x0000000000000000000000000000000000000000
        );
        address airdropAddress = address(
            new MerkleDistributor(_token, _merkleRoot)
        );
        airdrops[count] = AirdropData(airdropAddress);
        emit AirdropCreated(airdropAddress, count);
        count++;
    }
}