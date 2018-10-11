const R = require('ramda');

const converter = (data) => {
  const columnNames = R.map(R.head, R.reject((r) => R.type(r[1]) === 'Array', R.sortBy((r) => r[0], R.toPairs(data[0])))).join(',');

  const csv = R.map((r) => {
    const pairs = R.sortBy((r) => r[0], R.toPairs(r));


    const added = R.pipe(
      (r) => R.not(R.contains('bathrooms', R.map(R.head, r))) ? R.concat([['bathrooms', undefined]], r) : r,
      (r) => R.not(R.contains('beds', R.map(R.head, r))) ? R.concat([['beds', undefined]], r) : r,
      (r) => R.not(R.contains('property_type_id', R.map(R.head, r))) ? R.concat([['property_type_id', undefined]], r) : r
    )(pairs);


    const values = R.map(R.last, added);
    const filtered = R.reject((r) => R.type(r) === 'Array', values);

    const converted = R.map((r) => {
      r = `${r}`.replace(/"/g, '""');
      r = `${r}`.replace(/\n/g, '');

      if(R.contains(',', r) | R.contains('"', r)){
        return `"${r}"`;
      }else{
        return `${r}`;
      }
    }, filtered);

    return converted.join(',');
  }, data);


  return R.concat([columnNames], csv).join('\r\n');

};

module.exports = converter;
