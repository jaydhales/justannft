// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

struct Player {
    uint streetCred;
    uint strength;
    uint intelligence;
    uint steeze;
    uint experience;
    uint charisma;
}

contract JustAnNFT is
    ERC721("NathVille", "NTV"),
    VRFConsumerBaseV2,
    ConfirmedOwner
{
    using Strings for uint256;
    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256 randomWord;
    }
    mapping(uint256 => RequestStatus) public s_requests;
    Player[] public players;

    // past requests Id.
    uint256[] public requestIds;
    uint256 public lastRequestId;

    //  GOERLI VRF SETUP
    bytes32 keyHash =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint32 callbackGasLimit = 2500000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;
    uint64 subscriptionId;

    address _coordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;

    VRFCoordinatorV2Interface COORDINATOR =
        VRFCoordinatorV2Interface(_coordinator);

    constructor(
        uint64 _subID
    ) VRFConsumerBaseV2(_coordinator) ConfirmedOwner(msg.sender) {
        subscriptionId = _subID;
    }

    function requestRandomWords()
        external
        onlyOwner
        returns (uint256 requestId)
    {
        // Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({
            randomWord: 0,
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;

        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");

        uint _word = _randomWords[0];
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWord = _word;

        uint tokenID = players.length;
        

        uint streetCred = ((_word % 100) % 100);
        uint strength = (((_word % 10000) / 100) % 100);
        uint intelligence = (((_word % 1000000) / 10000) % 100);
        uint steeze = (((_word % 100000000) / 1000000) % 100);
        uint experience = (((_word % 10000000000) / 100000000) % 100);
        uint charisma = (((_word % 1000000000000) / 10000000000) % 100);

        players.push(
            Player(
                streetCred,
                strength,
                intelligence,
                steeze,
                experience,
                charisma
            )
        );

        _safeMint(msg.sender, tokenID);
       
    }

    function getTotalPlayers() external view returns (uint _num) {
        _num = players.length;
    }
}

// {
//     // using Strings for uint256;
//     // uint tokenCounter;
//     // function _baseURI() internal view virtual override returns (string memory) {
//     //     return "ipfs://QmbwJKXKET3sm4LhBpS2NNuirDja2tp1MH2JerGtKfUcy4/";
//     // }
//     // function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
//     //     _requireMinted(tokenId);
//     //     string memory baseURI = _baseURI();
//     //     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
//     // }
//     // function gift(address _to) public onlyOwner {
//     //     require(tokenCounter <= 10, "Max Nft reached");
//     //     tokenCounter++;
//     //     _safeMint(_to, tokenCounter);
//     // }
// }
