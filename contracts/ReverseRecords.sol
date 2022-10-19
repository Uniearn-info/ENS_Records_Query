pragma solidity ^0.7.4;pragma experimental ABIEncoderV2;
import "./Namehash.sol";
import '@ensdomains/ens/contracts/ENS.sol';
import '@ensdomains/ens/contracts/ReverseRegistrar.sol';
import '@ensdomains/resolver/contracts/Resolver.sol';

pragma solidity ^0.7.0;

contract ReverseRecords {
    ENS ens;
    ReverseRegistrar registrar;
    bytes32 private constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;

    /**
     * The `constructor` takes ENS registry address
     */
    constructor(ENS _ens) {
        ens = _ens;
        registrar = ReverseRegistrar(ens.owner(ADDR_REVERSE_NODE));
    }

    /**
     * Returns an array of string. If the given address does not have a reverse record or forward record setup, it returns an empty string.
     */
    function getNamesWithReverse(address[] calldata addresses) public view returns (string[] memory r) {
        r = new string[](addresses.length);
        for(uint i = 0; i < addresses.length; i++) {
            bytes32 node = getReverseNode(addresses[i]);
            address resolverAddress = ens.resolver(node);
            if(resolverAddress != address(0x0)){
                Resolver resolver = Resolver(resolverAddress);
                string memory name = resolver.name(node);
                if(bytes(name).length == 0 ){
                    continue;
                }
                bytes32 namehash = Namehash.namehash(name);
                address forwardResolverAddress = ens.resolver(namehash);
                if(forwardResolverAddress != address(0x0)){
                    Resolver forwardResolver = Resolver(forwardResolverAddress);
                    address forwardAddress = forwardResolver.addr(namehash);
                    if(forwardAddress == addresses[i]){
                        r[i] = name;
                    }
                }
            }
        }
        return r;
    }

    /**
     * Returns an array of string, If the given addresshave a reverse record. whether forward record setup, dont care
     */
    function getNames(address[] calldata addresses) public view returns (string[] memory r) {
        r = new string[](addresses.length);
        for(uint i = 0; i < addresses.length; i++) {
            bytes32 node = getReverseNode(addresses[i]);
            address resolverAddress = ens.resolver(node);
            if(resolverAddress != address(0x0)){
                Resolver resolver = Resolver(resolverAddress);
                string memory name = resolver.name(node);
                if(bytes(name).length == 0 ){
                    continue;
                }
                r[i] = name;
            }
        }
        return r;
    }
    
    /*
     * nodes: keccak256(domain)
     * According to the node array, query text parsing records.
     * key from：https://ensuser.com/docs/ens-improvement-proposals/ensip-5-text-records.html
     */
    function getTexts(bytes32[] memory nodes, string calldata key)  public view returns (string[] memory r) {
        r = new string[](nodes.length);
        for(uint i = 0; i < nodes.length; i++) {
            r[i] = getText(nodes[i], key);
        }
        return r;
    }

     /*
     * nodes: keccak256(domain)
     * According to the node query a single parsing record
     * key from：https://ensuser.com/docs/ens-improvement-proposals/ensip-5-text-records.html
     */    
     function getText(bytes32 node, string calldata key) public view  returns (string memory) {
        address resolverAddress = ens.resolver(node);
        if(resolverAddress != address(0x0)){
            Resolver resolver = Resolver(resolverAddress);
            return resolver.text(node, key);
        }
        return '';
    }

    // According to the names arrary, returns an array of name node
    // node = keccak256(name)    
    function getNodes(string[] memory names) public pure returns (bytes32[] memory r) {        
        r = new bytes32[](names.length);
        for(uint i = 0; i < names.length; i++) {
            r[i] = getNode(names[i]);
        }
        return r;
    }

    // According to the name, return name node, node = keccak256(name)
    function getNode(string memory name) public pure returns (bytes32) {   
         return Namehash.namehash(name);     
    }

    // According to the address arrary, returns an array of address reverse node
    function getReverseNodes(address[] calldata addres) public pure returns (bytes32[] memory r) {       
        r = new bytes32[](addres.length);
        for(uint i = 0; i < addres.length; i++) {
            r[i] = getReverseNode(addres[i]);
        }
        return r;
    }

    // According to the address, return address reverse node
    function getReverseNode(address addr) public pure returns (bytes32) {        
        return keccak256(abi.encodePacked(ADDR_REVERSE_NODE, sha3HexAddress(addr)));
    }

    function sha3HexAddress(address addr) private pure returns (bytes32 ret) {
        addr;
        ret; // Stop warning us about unused variables
        assembly {
            let lookup := 0x3031323334353637383961626364656600000000000000000000000000000000

            for { let i := 40 } gt(i, 0) { } {
                i := sub(i, 1)
                mstore8(i, byte(and(addr, 0xf), lookup))
                addr := div(addr, 0x10)
                i := sub(i, 1)
                mstore8(i, byte(and(addr, 0xf), lookup))
                addr := div(addr, 0x10)
            }

            ret := keccak256(0, 40)
        }
    }
}