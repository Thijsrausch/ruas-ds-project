const data = require('../generated/data.json');
const amenities = require('../amenities.json');
const R = require('ramda');
const gotIdList = R.map(function(r){return parseInt(r[0], 10)}, R.toPairs(amenities));


const offendingItems = R.map((r) => {
  return {id: r.id, missing:R.without(gotIdList, r.amenity_ids)}
  },R.filter(function (r) {
    return (R.without(gotIdList, r.amenity_ids)).length !== 0 && r.amenity_ids.length !== 0
  }, data)
);
console.log(offendingItems);
console.log(offendingItems.length);
