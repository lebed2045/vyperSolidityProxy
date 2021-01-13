pragma solidity ^0.6.10;

contract SolidityProxy {
    address public a;      // takes 20 bytes of the slot
    int64 public _empty0; // take another 12*8 bits of the slot, so bool would take the whole next slot
    int32 public _empty1;
    bool public b;
    uint256 public c;

    // for testing only
    address delegationTarget;

    constructor(address _a, address _delegationTarget
    ) public {
        a = _a;
//      b = false;
        c = block.timestamp + 2;
        delegationTarget = _delegationTarget;
    }


 // The proxy code is from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/Proxy.sol
 /**
 * @dev Delegates the current call to `implementation`.
 *
 * This function does not return to its internall call site, it will return directly to the external caller.
 */
    function _delegate(address implementation) internal {
        //        // solhint-disable-next-line no-inline-assembly
        assembly {
        // Copy msg.data. We take full control of memory in this inline assembly
        // block because it will not return to Solidity code. We overwrite the
        // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

        // Call the implementation.
        // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

        // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    /**
     * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
     * and {_fallback} should delegate.
     */
    function _implementation() internal view returns (address) {
        return delegationTarget;
    }

    /**
     * @dev Delegates the current call to the address returned by `_implementation()`.
     *
     * This function does not return to its internall call site, it will return directly to the external caller.
     */
    function _fallback() internal {
        _delegate(_implementation());
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
     * function in the contract matches the call data.
     */
    fallback () external payable {
        _fallback();
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
     * is empty.
     */
    receive () external payable {
        _fallback();
    }
}
