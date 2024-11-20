// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AccessControlDefaultAdminRules} from "@openzeppelin/contracts/access/extensions/AccessControlDefaultAdminRules.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract LoyaltyPoints is
    ERC20,
    ERC20Permit,
    ERC20Pausable,
    AccessControlDefaultAdminRules
{
    string private _name;
    string private _symbol;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(
        string memory name_,
        string memory symbol_,
        address initialAdmin_
    )
        ERC20(name_, symbol_)
        ERC20Permit(name_)
        AccessControlDefaultAdminRules(0, initialAdmin_)
    {
        _name = super.name();
        _symbol = super.symbol();

        if (initialAdmin_ == address(0)) {
            revert InvalidAddress();
        }
    }

    /// @notice Pauses the contract.
    function pause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    /// @notice Unpauses the contract.
    function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    /// @notice Returns the symbol of the token.
    /// @dev This is a custom function that overrides the OpenZeppelin function.
    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    /// @notice Sets the symbol of the token.
    /// @dev This gives the owner the ability to change the name of the token.
    function setSymbol(
        string calldata newSymbol
    ) public whenNotPaused onlyRole(DEFAULT_ADMIN_ROLE) {
        _symbol = newSymbol;
    }

    /// @notice Returns the name of the token.
    /// @dev This is a custom function that overrides the OpenZeppelin function.
    function name() public view override returns (string memory) {
        return _name;
    }

    /// @notice Sets the name of the token.
    /// @dev This gives the owner the ability to change the name of the token.
    function setName(
        string calldata newName
    ) public whenNotPaused onlyRole(DEFAULT_ADMIN_ROLE) {
        _name = newName;
    }

    /// @notice Mints point for a user by minter
    /// @param to The address of the user who needs point minted
    /// @param amount The amount of points being minted
    function mint(
        address to,
        uint256 amount
    ) public whenNotPaused onlyRole(MINTER_ROLE) {
        if (to == address(0)) {
            revert InvalidAddress();
        }
        _mint(to, amount);
    }

    /// @notice Transfers tokens from one account to another
    function transfer(
        address to,
        uint256 value
    ) public override whenNotPaused whenTransferable returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override whenNotPaused whenTransferable returns (bool) {
        return super.transferFrom(from, to, value);
    }
}
