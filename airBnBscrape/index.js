const R = require('ramda');

const generateUrlList = require('./buildUrl');
const downloader = require('./downLoader');
const parse = require('./parse');
const writeFile = require('./writeFile').writeFileJson;

(async () => {
  const urlList = generateUrlList();

  const jsonDownload = await Promise.all(
    R.map((r) => downloader(r).catch((someting) => {
      console.log('the download for url', r, 'caught');
      console.log(someting);
      return undefined
    }), urlList)
  );
  const cleanedJsonDownload = R.reject(R.isNil, R.flatten(jsonDownload));
  console.log(cleanedJsonDownload);
  const data = R.uniqBy((r) => r.id,R.flatten(R.map((r) => parse(r), cleanedJsonDownload)));

  writeFile(data)
})().catch((err) => {
  console.error(err)
});

// todo: get availabilities from listings
// todo: do pagination


