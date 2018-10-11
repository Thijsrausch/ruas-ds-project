const R = require('ramda');

const getBookingsUrls = require('./getBookingsUrls');
const downloadBookings = require('./downloadBookings');
const parseBookings = require('./parseBookings');

const getBookings = async (id) => {

	const bookingsUrls = getBookingsUrls(id);

	const bookingsJsons = await Promise.all(
		R.map((r) => downloadBookings(r).catch((something) => {
			console.log('the download for url', r, 'caught');
			console.log(something);
		return undefined
		}), bookingsUrls)
	);

	const cleanedBookingDownload = R.reject(R.isNil, bookingsJsons);
	console.log(cleanedBookingDownload);
	const data = R.uniqBy((r) => r.date,R.flatten(R.map((r) => parseBookings(r), cleanedBookingDownload)));

	return data;

}

module.exports = getBookings;