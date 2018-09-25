const R = require('ramda');

const data = [

];

const out = R.fromPairs(R.sortBy(function(r){return r[0]}, R.map(function(r){return [r.id, r.tag]}, data)));
console.log(out);
