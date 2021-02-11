pragma solidity ^0.5.3;


contract ERC1820Registry {
    function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
    function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address);
    function setManager(address _addr, address _newManager) external;
    function getManager(address _addr) public view returns (address);
}


/// Base client to interact with the registry.
contract ERC1820Client {
    ERC1820Registry internal erc1820Registry;
    constructor (address erc1820ContractAddress) internal {
        if (erc1820ContractAddress != address(0)) {
            erc1820Registry = ERC1820Registry(erc1820ContractAddress);
        } else {
            erc1820Registry = ERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
        }
    }

    function setInterfaceImplementation(string memory _interfaceLabel, address _implementation) internal {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        erc1820Registry.setInterfaceImplementer(address(this), interfaceHash, _implementation);
    }

    function interfaceAddr(address addr, string memory _interfaceLabel) internal view returns(address) {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        return erc1820Registry.getInterfaceImplementer(addr, interfaceHash);
    }

    function delegateManagement(address _newManager) internal {
        erc1820Registry.setManager(address(this), _newManager);
    }
}
