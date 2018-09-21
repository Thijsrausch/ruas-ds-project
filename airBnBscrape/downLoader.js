const request = require('request-promise');

const downloader = async (url) => {
  const options = {
    method: 'GET',
    uri: url,
    json: true, // Automatically stringifies the body to JSON
    headers: {
      "user-agent": "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"
    }
  };

  try {
    return await request(options);
  }catch (err) {
    console.error(err)
  }
};


module.exports = downloader;
