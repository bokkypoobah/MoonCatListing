#!/bin/sh

MOONCATRESCUEEVENTSDATA=MoonCatRescueEventsData.txt
MOONCATRESCUEEVENTSRESULTS=MoonCatRescueEventsResults.js

geth attach http://localhost:8545 << EOF | tee $MOONCATRESCUEEVENTSDATA

loadScript("deploymentData.js");

console.log("eth.blockNumber: " + eth.blockNumber);

var moonCat = eth.contract(MOONCATRESCUEABI).at(MOONCATRESCUEADDRESS);

var maxBlockNumber = eth.blockNumber;
var MOONCATRESCUEDEPLOYMENTBLOCKNUMBER = 4134866;
var PAGESIZE = 500000;

// Testing
// maxBlockNumber = MOONCATRESCUEDEPLOYMENTBLOCKNUMBER + PAGESIZE * 2;

console.log("RESULT: rescueEvents = [");

var fromBlock = MOONCATRESCUEDEPLOYMENTBLOCKNUMBER;
var rescueOrder = 0;
while (fromBlock < maxBlockNumber) {
  var toBlock = fromBlock + PAGESIZE;
  if (toBlock > maxBlockNumber) {
    toBlock = maxBlockNumber;
  }
  console.log("Processing from " + fromBlock + " to " + toBlock);
  var catRescuedEvents = moonCat.CatRescued({}, { fromBlock: fromBlock, toBlock: toBlock });
  catRescuedEvents.watch(function (error, result) {
      var timestamp = eth.getBlock(result.blockNumber).timestamp;
      console.log("RESULT: [" + rescueOrder++ + ", " + result.blockNumber + ", " + result.transactionIndex + ", \"" + result.transactionHash + "\", \"" + result.args.to + "\", \"" + result.args.catId + ", " + timestamp + "\"], ");
  });
  catRescuedEvents.stopWatching();
  fromBlock += PAGESIZE;
}
console.log("RESULT: ];");

EOF

grep -a "RESULT: " $MOONCATRESCUEEVENTSDATA | sed "s/RESULT: //" > $MOONCATRESCUEEVENTSRESULTS
cat $MOONCATRESCUEEVENTSRESULTS
