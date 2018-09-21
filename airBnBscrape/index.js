const R = require('ramda');

const generateUrlList = require('./buildUrl');
const downloader = require('./downLoader');
const parse = require('./parse');


(async () => {
  const urlList = generateUrlList();
  const data = await downloader(urlList[0]);
  parse(data);

})().catch((err) => {
  console.error(err)
});

// todo: get availabilities from listings
// todo: do pagination


