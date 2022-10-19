# Reverse records


## How to setup

```
git clone https://github.com/js-kingdata/ENS_Records_Query
cd ENS_Records_Query-records
```


## Smart contract API

### getNamesWithReverse([address])
Returns an array of string. If the given address does not have a reverse record or forward record setup, it returns an empty string.

### getNames([address])
Returns an array of string, If the given addresshave a reverse record. whether forward record setup, dont care

### getTexts([node], key)
According to the node array, query text parsing records. key from : https://ensuser.com/docs/ens-improvement-proposals/ensip-5-text-records.html

### getText(node, key)
According to the node query a single parsing record. key from : https://ensuser.com/docs/ens-improvement-proposals/ensip-5-text-records.html

### getNodes([names])
According to the names arrary, returns an array of name node
node = keccak256(name)

### getNode(name)
According to the name, return name node
node = keccak256(name)

### getReverseNodes([address])
According to the address arrary, returns an array of address reverse node

### getReverseNode(address)
According to the address, return address reverse node


## Usage note

Make sure to compare that the returned names match with the normalised names to prevent from [homograph attack](https://en.wikipedia.org/wiki/IDN_homograph_attack)

Example

```js
const ens = web3.eth.Contract(ReverseRecordsABI, ReverseRecordsContractAddress);
await ens.methods.getText("0xd655d0bf268edc06ac36568551eb0620a257159d813f9dcca26a9aa9019d0ef4", "avatar").call({ from: ReverseRecordsContractAddress, gasPrice: "0" })
await ens.methods.getText("0xa44ac90ef126a9485cdd684d676c2928103e6d480dca1170cad7836ab3d08ec0", "com.twitter").call({ from: ReverseRecordsContractAddress, gasPrice: "0" })
await ens.methods.getNodes(['smartearn.eth', '', 'keenz.eth']).call({ from: ReverseRecordsContractAddress, gasPrice: "0" })
await ens.methods.getReverseNode("0xa1fA4a9200f6A273a941c766021B8eE29e5D936e").call({ from: ReverseRecordsContractAddress, gasPrice: "0" })

await ens.methods.getReverseNodes(["0xa1fA4a9200f6A273a941c766021B8eE29e5D936e", "0x473780deaf4a2ac070bbba936b0cdefe7f267dfc", "0xf71946496600e1e1d47b8A77EB2f109Fd82dc86a"]).call({ from: ReverseRecordsContractAddress, gasPrice: "0" })
await ens.methods.getNamesWithReverse(["0xa1fA4a9200f6A273a941c766021B8eE29e5D936e", "0x473780deaf4a2ac070bbba936b0cdefe7f267dfc", "0xf71946496600e1e1d47b8A77EB2f109Fd82dc86a"]).call({ from: ReverseRecordsContractAddress, gasPrice: "0" })
```


## Deployed contract address

- Mainnet: [0x1254c3d5adfca129f9787d98d0a3fa51833483f7](https://etherscan.io/address/0x1254c3d5adfca129f9787d98d0a3fa51833483f7)
