pragma solidity ^0.4.11;

contract MediaRegistry {
    
    address public owner; 
    mapping (address => bool)  moderator;
    mapping (bytes32 => entry) entries;
    mapping (string  => bool)  official_links;
    
    struct entry
    {
        string name;
        string link;
        string metadata;
    }
    
    function add_entry(string _name, string _link, string _metadata) access_restriction
    {
        entries[bytes32( sha3( _name ) )].name     = _name;
        entries[bytes32( sha3( _name ) )].link     = _link;
        entries[bytes32( sha3( _name ) )].metadata = _metadata;
        official_links[_link] = true;
    }
    
    function remove_entry(string _name) access_restriction
    {
        official_links[entries[bytes32(sha3(_name))].link] = false;
        delete(entries[bytes32( sha3( _name ) )].name);
        delete(entries[bytes32( sha3( _name ) )].link);
        delete(entries[bytes32( sha3( _name ) )].metadata);
    }
    
    function get_entry(string _name) constant returns (string, string, string)
    {
        return ( entries[bytes32( sha3( _name ) )].name, entries[bytes32( sha3( _name ) )].link, entries[bytes32( sha3( _name ) )].metadata );
    }
    
    function is_official(string _link) constant returns (bool)
    {
        return official_links[_link];
    }
    
    function hire(address _who) only_owner
    {
        moderator[_who] = true;
    }
    
    function fire(address _who) only_owner
    {
        moderator[_who] = false;
    }
    
    function transfer_ownership(address _who) only_owner
    {
        owner = _who;
    }
    
    modifier only_owner
    {
        require(msg.sender == owner);
        _;
    }
    
    modifier access_restriction
    {
        require(msg.sender == owner || moderator[msg.sender]);
        _;
    }
}
