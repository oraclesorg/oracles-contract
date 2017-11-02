let big = require('./util/bigNum.js').big;

const ETHER = big(10).toPower(18);
const SYSTEM_OWNER_ADDRESS = '0x338a7867a35367d120011b2da1d8e2a8a60b9bc0'
const INITIAL_KEYS_LIMIT = 25;

module.exports = {
    ETHER,
    SYSTEM_OWNER_ADDRESS,
    INITIAL_KEYS_LIMIT,
}
