function makeBigNumber(val) {
    return new web3.BigNumber(val);
}

module.exports = {
    big: makeBigNumber
}
