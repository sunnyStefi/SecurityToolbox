# Registry fuzzing exercise

## Protocol

A registry contract allows callers to register by paying a fixed fee in ETH.
If the caller sends too little ETH, execution should revert.
If the caller sends too much ETH, the contract should give back the change.
Things look good according to the unit test we coded in the Registry.t.sol contract.

## Assignment

Code at least one fuzz test for the Registry contract.
The test must be able to detect a bug in the register function.
