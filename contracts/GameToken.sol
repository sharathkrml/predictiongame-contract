// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GameToken is ERC20, Ownable {
    mapping(address => bool) public notFirstTime;

    constructor() ERC20("GameToken", "GTK") {}

    function mint() public payable {
        if (notFirstTime[msg.sender]) {
            require(msg.value == 0.01 ether, "Not 0.01 ether");
            return _mint(msg.sender, 10 ether);
        }
        notFirstTime[msg.sender] = true;
        return _mint(msg.sender, 10 ether);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
