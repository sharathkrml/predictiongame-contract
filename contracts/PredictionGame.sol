// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract PredictionGame {
    struct Prediction {
        uint value;
        uint time;
        uint difference;
        address from;
    }
    event NewPrediction(uint value, uint time, address from);
    event Result(Prediction[]);
    Prediction[] public predictions;

    function predict(uint _value) external {
        require(predictions.length < 10, "maximum predictions completed");
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
        // emit Result and reset
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
        delete predictions;
    }
}
