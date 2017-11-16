let big = require('./util/bigNum.js').big;

const ETHER = big(10).toPower(18);
const SYSTEM_OWNER_ADDRESS = '0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0'
const TRUE_OWNER_ADDRESS = '0xdd0bb0e2a1594240fed0c2f2c17c1e9ab4f87126'
const INITIAL_KEYS_LIMIT = 25;

module.exports = {
    ETHER,
    SYSTEM_OWNER_ADDRESS,
    TRUE_OWNER_ADDRESS,
    INITIAL_KEYS_LIMIT,
}
