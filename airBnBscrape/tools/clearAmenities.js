const R = require('ramda');

const amenities = require('../amenities.json');

const data = [];

const out =  R.map(function(r){return [r.id, r.tag]}, data);
const combined = R.fromPairs(R.sortBy(function(r){return r[0]}, R.concat(out, R.toPairs(amenities))))
console.log(JSON.stringify(combined));
