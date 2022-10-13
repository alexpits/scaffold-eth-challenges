// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ExampleExternalContract is Ownable, AccessControl {

  bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");

  bool public completed;

  function setupWithdrawRole(address withdrawer) public {
    _setupRole(WITHDRAW_ROLE, withdrawer);
  }

  function complete() public payable {
    completed = true;
  }

  function incomplete() public {
    if (completed) {
      completed = false;
    }
  }

  function withdraw() public {
    require(hasRole(WITHDRAW_ROLE, msg.sender), "Permission denied");
    (bool sent, bytes memory data) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to send Ether");
  }
}
