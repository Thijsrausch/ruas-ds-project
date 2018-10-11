const delay = require('./delay');

const randomDelay = async (minWait, maxWait) => {
	//wait a random time so we don't get cought
	const msInSec = 1000; //ms
	await delay((Math.random() * msInSec * maxWait) + minWait * msInSec);
}

module.exports = randomDelay;