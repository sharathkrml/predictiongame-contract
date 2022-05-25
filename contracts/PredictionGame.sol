// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PredictionGame{
    struct Prediction{
        uint value;
        uint time;
        address from;
    }
    event NewPrediction(
        uint value,
        uint time,
        address from
    );
    Prediction[10] public predictions;
    uint public count;
    function predict(uint _value) external {
        require(count<10,"maximum predictions completed");
        predictions[count]=Prediction(_value,block.timestamp,msg.sender);
        emit NewPrediction(_value, block.timestamp, msg.sender);
        count++;
    }
}