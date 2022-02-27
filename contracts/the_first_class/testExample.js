const Counter = artifacts.require("Counter");
const counterAddr = "0x5dd0f8e44a7d3e1a6bd1d75f59533883902e1e0e";

module.exports = async function test01() {
    let counter = await Counter.at(counterAddr);
    await counter.add();
    let value = await counter.counter();
    console.log("----目前counter的值为----" + value);
};
