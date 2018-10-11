const R = require('ramda');

const request = require('request-promise');
const userAgents = require('user-agent-array');

const randomDelay = require('./utils/randomDelay');
const getRandomFromArray = require('./utils/getRandomFromArray');

const downloadBookings = async (url) => {

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
	console.error('while getting: ', options.uri);
	console.error(err);
	}

};

module.exports = downloadBookings;