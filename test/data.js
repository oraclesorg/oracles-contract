let big = require('./util/bigNum.js').big;

const ETHER = big(10).toPower(18);
const SYSTEM_OWNER_ADDRESS = '0x338a7867A35367D120011B2DA1D8E2a8A60B9bC0'
const INITIAL_KEYS_LIMIT = 12;
const LICENSES_LIMIT = 52;

module.exports = {
    ETHER,
    SYSTEM_OWNER_ADDRESS,
    INITIAL_KEYS_LIMIT,
    LICENSES_LIMIT
}
