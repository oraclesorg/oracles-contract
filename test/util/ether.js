function addressFromNumber(num) {
    let hexNum = num.toString(16);
    return '0x' + hexNum.padStart(40, '0');
}

module.exports = {
    addressFromNumber,
}
