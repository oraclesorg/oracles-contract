function etherUsedForTx(res) {
    let gasUsed = res.receipt.gasUsed;
    let gasPrice = web3.eth.getTransaction(res.tx).gasPrice;
    return gasPrice.mul(gasUsed);
}

module.exports = {
    etherUsedForTx: etherUsedForTx
}
