// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

function timeCalc(uint256 rate, uint256 t0) view returns(uint256) {
    return (block.timestamp - t0) * rate;
}
