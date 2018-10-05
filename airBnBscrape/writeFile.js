const fs = require('fs');
const csvConvert = require('./converter');

const makeGeneratedDir = () => {
  try {
    fs.mkdirSync('./generated/');
  } catch (err) {
    console.error('I think the directory already exists');
  }
};

const writeFileJson = (data) => {
  makeGeneratedDir();
  fs.writeFileSync('./generated/data.json', JSON.stringify(data));
};

const writeFileCsv = (data) => {
  makeGeneratedDir();
  fs.writeFileSync('./generated/data.csv', csvConvert(data));
};

module.exports = {
  writeFileJson,
  writeFileCsv
};
