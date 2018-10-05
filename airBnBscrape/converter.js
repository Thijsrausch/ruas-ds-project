const R = require('ramda');

const converter = (data) => {
  const columnNames = R.map(R.head, R.reject((r) => R.type(r[1]) === "Array", R.sortBy((r) => r[0], R.toPairs(data[0])))).join(',');

  const csv =  R.map((r) => {
    const pairs = R.sortBy((r) => r[0], R.toPairs(r));
    const values = R.map(R.last, pairs);

    const filtered = R.reject((r) => R.type(r) === "Array", values);

    const converted = R.map((r) => {
      r = `${r}`.replace(/"/g, '""');
      return `"${r}"`;
    }, filtered);

    return converted.join(',');
  }, data);


  return R.concat([columnNames], csv).join('\r\n');

};

module.exports = converter;
