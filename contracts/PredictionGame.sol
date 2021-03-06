// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

contract PredictionGame is KeeperCompatible {
    IERC20 IGameToken;
    AggregatorV3Interface internal priceFeed;
    struct Prediction {
        int value;
        uint time;
        int difference;
        address from;
    }
    event NewPrediction(
        uint indexed contestId,
        int value,
        uint time,
        address from
    );
    event Result(uint indexed contestId, int actual, Prediction[]);
    event ContestCancelled(uint indexed contestId);
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
    uint public lastTimeStamp;
    uint public immutable interval;
    string public name;
    uint public contestId;

    constructor(
        address _tokenAddress,
        address _AggregatorAddress,
        uint _interval,
        string memory _name
    ) {
        IGameToken = IERC20(_tokenAddress);
        priceFeed = AggregatorV3Interface(_AggregatorAddress);
        lastTimeStamp = block.timestamp;
        interval = _interval;
        name = _name;
    }

    function predict(int _value) external {
        require(predictions.length < 10, "maximum predictions completed");
        IGameToken.transferFrom(msg.sender, address(this), 1 ether);
        predictions.push(Prediction(_value, block.timestamp, 0, msg.sender));
        emit NewPrediction(contestId, _value, block.timestamp, msg.sender);
    }

    function _getDifference(int _actualValue) internal {
        for (uint i = 0; i < predictions.length; i++) {
            predictions[i].difference = predictions[i].value >= _actualValue
                ? predictions[i].value - _actualValue
                : _actualValue - predictions[i].value;
        }
    }

    function currentResult() external view returns (int, uint) {
        (, int price, , , ) = priceFeed.latestRoundData();
        return (price, block.timestamp);
    }

    function getResult() internal {
        (, int _actualValue, , , ) = priceFeed.latestRoundData();
        if (predictions.length < 10) {
            emit ContestCancelled(contestId);
            contestId++;
            for (uint i = 0; i < predictions.length; i++) {
                IGameToken.transfer(predictions[i].from, 1 ether);
            }
            return delete predictions;
        }
        Prediction memory temp;
        _getDifference(_actualValue);
        for (uint i = 0; i < 10; i++) {
            for (uint j = 0; j < 10 - i - 1; j++) {
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
        emit Result(contestId, _actualValue, predictions);
        contestId++;
        for (uint i = 0; i < 10; i++) {
            IGameToken.transfer(predictions[i].from, rewardArray[i]);
        }
        delete predictions;
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        //We highly recommend revalidating the upkeep in the performUpkeep function
        if ((block.timestamp - lastTimeStamp) > interval) {
            lastTimeStamp = block.timestamp;
            getResult();
        }
        // We don't use the performData in this example. The performData is generated by the Keeper's call to your checkUpkeep function
    }
}
