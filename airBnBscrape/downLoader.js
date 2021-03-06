const request = require('request-promise');
const userAgents = require('user-agent-array');

const getRandomFromArray = require('./utils/getRandomFromArray');
const randomDelay = require('./utils/randomDelay');

const downloader = async (url) => {
  
  await randomDelay(1, 60);

  const options = {
    method: 'GET',
    uri: url,
    json: true, // Automatically stringifies the body to JSON
    headers: {
      "user-agent": getRandomFromArray(userAgents)
    }
  };

  try {
    console.log('getting:', options.uri);
    return await request(options);
  }catch (err) {
    console.error('received error: ', err.statusCode);
    console.error('while getting: ', options.uri)
  }
};

const downloadWithPagination = async (url) => {
  const baseUrl = url;
  const jsonArray = [];

  let json = await downloader(url);

  if(json === undefined || json.explore_tabs === undefined){
    // if the first one broke than we return nothing and filter it out
    return undefined;
  }

  jsonArray.push(json);

  try {
    while (json.explore_tabs[0].pagination_metadata.has_next_page) {
      console.log('in loop take:' + jsonArray.length);
      console.log('has next page:', json.explore_tabs[0].pagination_metadata.has_next_page);

      const offset = json.explore_tabs[0].pagination_metadata.section_offset;
      url = baseUrl + '&section_offset=' + offset;
      json = await downloader(url);

      if(json === undefined || json.explore_tabs === undefined){
        break;
      }

      jsonArray.push(json)
    }
  }catch (err){
    console.error(err);
  }

  console.log(jsonArray);
  return jsonArray
};


module.exports = downloadWithPagination;
