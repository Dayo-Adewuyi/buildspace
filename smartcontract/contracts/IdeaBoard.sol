//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

interface IBuildspaceNft {
    function balanceOf(address owner) external view returns (uint256);
}

contract IdeaBoard is Ownable {
    constructor(address _IBuildspaceNft) {
        buildspaceNFT = IBuildspaceNft(_IBuildspaceNft);
    }

    IBuildspaceNft public buildspaceNFT;
    
    
    modifier onlyNFTholder() {
        require(buildspaceNFT.balanceOf(msg.sender) > 0, "NOT A WARRIOR");
        _;
    }

    struct Post {
        uint Id;
        string post;
        uint likes;
        uint dislikes;
        uint timestamp;
        address uploader;
        bool isPublic;
    }

    event NewPost(
        uint Id,
        string post,
        uint likes,
        uint dislikes,
        uint timestamp,
        address uploader
    );

    mapping(uint => Post) public allPosts;
    mapping(uint => mapping(address => bool)) public likedPost;
    mapping(uint => mapping(address => bool)) public dislikedPost;

    uint public postId;

    uint[] public reportedFiles;

    function createPost(string memory _post) public onlyNFTholder {
        require(bytes(_post).length > 0, "you cannot post empty messages");
        postId++;

        allPosts[postId] = Post(
            postId,
            _post,
            0,
            0,
            block.timestamp,
            msg.sender,
            true
        );
        emit NewPost(postId, _post, 0, 0, block.timestamp, msg.sender);
    }

    function fetchPost() public view returns (Post[] memory) {
        uint currentIndex = 0;
        Post[] memory ideas = new Post[](postId);
        for (uint i = 0; i < postId; i++) {
            if (allPosts[i + 1].isPublic == true) {
                uint currentId = allPosts[i + 1].Id;
                Post storage currentIdea = allPosts[currentId];
                ideas[currentIndex] = currentIdea;
                currentIndex += 1;
            }
        }
        return ideas;
    }

    function fetchUserPost() public view returns (Post[] memory) {
        uint itemCount = 0;
        uint currentIndex = 0;
        uint totalPost = postId;

        for (uint i = 0; i < totalPost; i++) {
            if (allPosts[i + 1].uploader == msg.sender) {
                itemCount += 1;
            }
        }
        Post[] memory items = new Post[](itemCount);
        for (uint i = 0; i < totalPost; i++) {
            if (allPosts[i + 1].uploader == msg.sender) {
                uint currentId = allPosts[i + 1].Id;
                Post storage currentItem = allPosts[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function like(uint Id) public onlyNFTholder {
        require(likedPost[Id][msg.sender] == false, "you have already liked this post");
        allPosts[Id].likes++;
        likedPost[Id][msg.sender] = true;
    }

    function dislike(uint Id) public onlyNFTholder {
       require(dislikedPost[Id][msg.sender] == false, "you have already disliked this post");  
        allPosts[Id].dislikes++;
        dislikedPost[Id][msg.sender] = true;
    }

    function report(uint Id) public onlyNFTholder {
        reportedFiles.push(Id);
    }

    function makePrivate(uint Id) public onlyOwner {
        allPosts[Id].isPublic = false;

        delete reportedFiles;
    }
}
