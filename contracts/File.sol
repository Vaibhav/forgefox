contract File {
    address FileCreator;
    bytes32 FileHash;
    bytes32 FileMetadataHash;
    uint    FileAddedAt;

    event FileCreated(
        address indexed _from,
        bytes32 hash,
        address indexed _id
    );

    function File(bytes32 hash, bytes32 metadataHash) public payable {
        FileCreator = msg.sender;
        FileHash = hash;
        FileMetadataHash = metadataHash;
        FileAddedAt = block.timestamp;

        FileCreated(msg.sender, hash, this);
    }

    function getFile() constant public returns (address, bytes32, bytes32, uint) {
        return (FileCreator, FileHash, FileMetadataHash, FileAddedAt);
    }
}