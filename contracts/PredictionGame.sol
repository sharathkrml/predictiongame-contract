// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PredictionGame {
    IERC20 IGameToken;
    struct Prediction {
        uint value;
        uint time;
        uint difference;
        address from;
    }
    event NewPrediction(uint value, uint time, address from);
    event Result(Prediction[]);
    event ContestCancelled();
    uint[10] public rewardArray = [
        4000000000000000000,
        2500000000000000000,
        1500000000000000000,
        750000000000000000,
        250000000000000000,
        200000000000000000,
        200000000000000000,
        200000000000000000,
        200000000000000000,
        200000000000000000
    ];
    Prediction[] public predictions;

    constructor(address _tokenAddress) {
        IGameToken = IERC20(_tokenAddress);
    }

    function predict(uint _value) external {
        require(predictions.length < 10, "maximum predictions completed");
        IGameToken.transferFrom(msg.sender, address(this), 1 ether);
        predictions.push(Prediction(_value, block.timestamp, 0, msg.sender));
        emit NewPrediction(_value, block.timestamp, msg.sender);
    }

    function _getDifference(uint _actualValue) internal {
        for (uint i = 0; i < predictions.length; i++) {
            predictions[i].difference = predictions[i].value >= _actualValue
                ? predictions[i].value - _actualValue
                : _actualValue - predictions[i].value;
        }
    }

    function getResult(uint _actualValue) external {
        if (predictions.length < 10) {
            emit ContestCancelled();
            for (uint i = 0; i < predictions.length; i++) {
                IGameToken.transfer(predictions[i].from, 1 ether);
            }
            return delete predictions;
        }
        Prediction memory temp;
        _getDifference(_actualValue);
        for (uint i = 0; i < predictions.length; i++) {
            for (uint j = 0; j < predictions.length - i - 1; j++) {
                // if current amt > next amt
                if (
                    predictions[j].difference > predictions[j + 1].difference ||
                    (predictions[j].difference ==
                        predictions[j + 1].difference &&
                        predictions[j].time > predictions[j + 1].time)
                ) {
                    temp = predictions[j];
                    predictions[j] = predictions[j + 1];
                    predictions[j + 1] = temp;
                }
            }
        }
        emit Result(predictions);
        for (uint i = 0; i < 10; i++) {
            IGameToken.transfer(predictions[i].from, rewardArray[i]);
        }
        delete predictions;
    }
}
