// File: v1-mining/interface/ISlotcoinInvite.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.7.4;

interface ISlotcoinInviteV1 {

    struct UserInfo {
        address upper;//upper
        address[] lowers;//lowers
        uint256 startBlock;//startBlock
    }

    event InviteV1(address indexed owner, address indexed upper, uint256 indexed height);

    function inviteCount() external view returns (uint256);

    function inviteUpper1(address) external view returns (address);

    function inviteUpper2(address) external view returns (address, address);

    function inviteLower1(address) external view returns (address[] memory);

    function inviteLower2(address) external view returns (address[] memory, address[] memory);

    function inviteLower2Count(address) external view returns (uint256, uint256);
    

    function acceptInvitation(address) external returns (bool);
    

}

// File: v1-mining/library/ErrorCode.sol


pragma solidity 0.7.4;

library ErrorCode {

    string constant FORBIDDEN = 'Slotcoin:FORBIDDEN';
    string constant IDENTICAL_ADDRESSES = 'Slotcoin:IDENTICAL_ADDRESSES';
    string constant ZERO_ADDRESS = 'Slotcoin:ZERO_ADDRESS';
    string constant INVALID_ADDRESSES = 'Slotcoin:INVALID_ADDRESSES';
    string constant BALANCE_INSUFFICIENT = 'Slotcoin:BALANCE_INSUFFICIENT';
    string constant REWARDTOTAL_LESS_THAN_REWARDPROVIDE = 'Slotcoin:REWARDTOTAL_LESS_THAN_REWARDPROVIDE';
    string constant PARAMETER_TOO_LONG = 'Slotcoin:PARAMETER_TOO_LONG';
    string constant REGISTERED = 'Slotcoin:REGISTERED';
    string constant MINING_NOT_STARTED = 'Slotcoin:MINING_NOT_STARTED';
    string constant END_OF_MINING = 'Slotcoin:END_OF_MINING';
    string constant POOL_NOT_EXIST_OR_END_OF_MINING = 'Slotcoin:POOL_NOT_EXIST_OR_END_OF_MINING';
    
}

// File: v1-mining/implement/SlotcoinInviteV1.sol


pragma solidity 0.7.4;



contract SlotcoinInviteV1 is ISlotcoinInviteV1 {

    address public constant ZERO = address(0);
    uint256 public startBlock;
    address[] public inviteUserInfoV1;
    mapping(address => UserInfo) public inviteUserInfoV2;

    constructor () {
        startBlock = block.number;
    }
    
    function inviteCount() override external view returns (uint256) {
        return inviteUserInfoV1.length;
    }

    function inviteUpper1(address _owner) override external view returns (address) {
        return inviteUserInfoV2[_owner].upper;
    }

    function inviteUpper2(address _owner) override external view returns (address, address) {
        address upper1 = inviteUserInfoV2[_owner].upper;
        address upper2 = address(0);
        if (address(0) != upper1) {
            upper2 = inviteUserInfoV2[upper1].upper;
        }

        return (upper1, upper2);
    }

    function inviteLower1(address _owner) override external view returns (address[] memory) {
        return inviteUserInfoV2[_owner].lowers;
    }

    function inviteLower2(address _owner) override external view returns (address[] memory, address[] memory) {
        address[] memory lowers1 = inviteUserInfoV2[_owner].lowers;
        uint256 count = 0;
        uint256 lowers1Len = lowers1.length;
        for (uint256 i = 0; i < lowers1Len; i++) {
            count += inviteUserInfoV2[lowers1[i]].lowers.length;
        }
        address[] memory lowers;
        address[] memory lowers2 = new address[](count);
        count = 0;
        for (uint256 i = 0; i < lowers1Len; i++) {
            lowers = inviteUserInfoV2[lowers1[i]].lowers;
            for (uint256 j = 0; j < lowers.length; j++) {
                lowers2[count] = lowers[j];
                count++;
            }
        }
        
        return (lowers1, lowers2);
    }

    function inviteLower2Count(address _owner) override external view returns (uint256, uint256) {
        address[] memory lowers1 = inviteUserInfoV2[_owner].lowers;
        uint256 lowers2Len = 0;
        uint256 len = lowers1.length;
        for (uint256 i = 0; i < len; i++) {
            lowers2Len += inviteUserInfoV2[lowers1[i]].lowers.length;
        }
        
        return (lowers1.length, lowers2Len);
    }


    function acceptInvitation(address _inviter) override external returns (bool) {
        require(msg.sender != _inviter, ErrorCode.FORBIDDEN);
        UserInfo storage user = inviteUserInfoV2[msg.sender];
        require(0 == user.startBlock, ErrorCode.REGISTERED);
        UserInfo storage upper = inviteUserInfoV2[_inviter];
        if (0 == upper.startBlock) {
            upper.upper = ZERO;
            upper.startBlock = block.number;
            inviteUserInfoV1.push(_inviter);
            
            emit InviteV1(_inviter, upper.upper, upper.startBlock);
        }
        user.upper = _inviter;
        upper.lowers.push(msg.sender);
        user.startBlock = block.number;
        inviteUserInfoV1.push(msg.sender);
        
        emit InviteV1(msg.sender, user.upper, user.startBlock);

        return true;
    }


}