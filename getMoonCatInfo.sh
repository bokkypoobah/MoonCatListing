#!/bin/sh

geth attach http://localhost:8545 << EOF

loadScript("deploymentData.js");
loadScript("MoonCatRescueEventsResults.js");

console.log(JSON.stringify(rescueEvents));

exit;

// console.log("MoonCat Address: " + MOONCATRESCUEADDRESS);
// console.log("MoonCat ABI: " + JSON.stringify(MOONCATRESCUEABI));
console.log("eth.blockNumber: " + eth.blockNumber);

var moonCat = eth.contract(MOONCATRESCUEABI).at(MOONCATRESCUEADDRESS);

// var catIds = moonCat.getCatOwners().call({ gas: 30000000 });
// console.log("catIds: " + JSON.stringify(catIds));

var MAX = 100;


var MOONCATRESCUEDEPLOYMENTBLOCKNUMBER = 4134866;
var PAGESIZE = 100000;
// var toBlock = eth.blockNumber;
var fromBlock = MOONCATRESCUEDEPLOYMENTBLOCKNUMBER;
var toBlock = MOONCATRESCUEDEPLOYMENTBLOCKNUMBER + PAGESIZE;
var i;
var catRescuedEvents = moonCat.CatRescued({}, { fromBlock: fromBlock, toBlock: toBlock });
i = 0;
catRescuedEvents.watch(function (error, result) {
    console.log("RESULT: CatRescued " + i++ + " #" + result.blockNumber + ": to=" + result.args.to + " catId=" + result.args.catId);
});
catRescuedEvents.stopWatching();



// var totalSupply = moonCat.totalSupply();
// console.log("rescueIndex, catId, owner, name");
// for (var i = 0; i < totalSupply && i < MAX; i++) {
//   var catId = moonCat.rescueOrder(i);
//   var owner = moonCat.catOwners(catId);
//   var name = moonCat.catNames(catId);
//   if (name == "0x0000000000000000000000000000000000000000000000000000000000000000") {
//     name = "";
//   } else {
//     name = web3.toAscii(name);
//   }
//   console.log(i + ", " + catId + ", " + owner + ", " + name);
// }



EOF
