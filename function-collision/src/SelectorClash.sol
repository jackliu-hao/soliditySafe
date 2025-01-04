// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract SelectorClash {
    // 攻击是否成功
    bool public solved;
    // 事件，查看是否执行成功

    event CrossChainExecuted(bool success);
    event motifySolved(bool solved);

    // 攻击者需要调用这个函数，但是调用者 msg.sender 必须是本合约。
    function putCurEpochConPubKeyBytes(bytes memory _bytes) public {
        require(msg.sender == address(this), "Not Owner");
        solved = true;
        emit motifySolved(solved);
    }

    // 有漏洞，攻击者可以通过改变 _method 变量碰撞函数选择器，调用目标函数并完成攻击。
    function executeCrossChainTx(bytes memory _method, bytes memory _bytes, bytes memory _bytes1, uint64 _num)
        public
        returns (bool success)
    {
        (success,) = address(this).call(
            abi.encodePacked(
                // 取函数选择器
                bytes4(keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))),
                // 取参数
                abi.encode(_bytes, _bytes1, _num)
            )
        );
        emit CrossChainExecuted(success);
    }

    // 判断攻击是否成功
    function isAttackOk() public view returns (string memory flag) {
        if (solved) {
            flag = "Attack success!";
        } else {
            flag = "Attack failed!";
        }
    }
}
