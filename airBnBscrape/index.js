const R = require('ramda');

const generateUrlList = require('./buildUrl');
const downloader = require('./downLoader');
const parse = require('./parse');
const writeFile = require('./writeFile');

(async () => {
  const urlList = generateUrlList();

  const jsonDownload = await downloader(urlList[0]);
  const data = parse(jsonDownload);


  writeFile(data)
})().catch((err) => {
  console.error(err)
});

// todo: get availabilities from listings
// todo: do pagination


