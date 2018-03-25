contract FileContract {

  address FileContractAdmin;

  struct File {
    address creator;
    bytes32 fileHash;
    bytes32 metadataHash;
    bytes32 ipfsPath;
    uint addedAt; 
  }

  //TODO: DO RESEARCH ON STORAGE OF FILES AS MAPPING OR ARRAY
  mapping ( bytes32 => File ) FileVersions; //Different versions of the same file
  bytes32[] filesByHashes;
  uint mapSize;

  function FileContract() public payable {
    FileContractAdmin = msg.sender;
    mapSize = 0;
  }

  modifier onlyAdmin() {
      if (msg.sender != FileContractAdmin) //FileContractAdmin is a User Smart Contract
        revert();
      // Do not forget the "_;"! It will be replaced by the actual function body when the modifier is used.
      _;
  }

  function updateFile(bytes32 ipfsPath, 
                      bytes32 file_hash, 
                      bytes32 metadata_Hash) public returns (bool success) {

    address creator = msg.sender;

    File storage file = FileVersions[file_hash];

    // don't overwrite existing entries, and make sure handle isn't null
    if(file.fileHash == 0 && metadata_Hash.length != 0) {
      FileVersions[file_hash].creator = creator;
      FileVersions[file_hash].fileHash = file_hash;
      FileVersions[file_hash].ipfsPath = ipfsPath;
      FileVersions[file_hash].metadataHash = metadata_Hash;
      FileVersions[file_hash].addedAt = block.timestamp;

      filesByHashes.push(file_hash);  // adds an entry for this user to the user 'whitepages'
      mapSize += 1;
      return true;
    } else {
      return false; // either handle was null, or a user with this handle already existed
    }
  }


  function verifyFile(bytes32 file_hash, bytes32 meta_hash) public returns (bool) {
    return (FileVersions[filesByHashes[mapSize-1]].fileHash == file_hash 
            && FileVersions[filesByHashes[mapSize-1]].metadataHash == meta_hash);
  }


  function getAdmin() constant public returns (address) { return FileContractAdmin; }

  function getFiles() constant public returns (bytes32[]) { return filesByHashes; }
  
  function getFile(bytes32 file_hash) constant public returns (address,bytes32,bytes32,bytes32,uint) {
    File storage file = FileVersions[file_hash];

    return (file.creator, file.fileHash, file.ipfsPath, file.metadataHash, file.addedAt);
  }

}
