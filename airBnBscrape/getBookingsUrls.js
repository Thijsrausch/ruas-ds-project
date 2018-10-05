const R = require('ramda');

const getBookingUrls = (id) => {

	const currentDate = new Date();
	// + 1 to compensate for starting to count at 0
	const currentMonth = currentDate.getMonth() + 1;
	const currentYear = currentDate.getFullYear();
	
	const months = R.addIndex(R.map)((r, i) => {
	   	return currentMonth+i;
	  },R.repeat(1, 13));

	const values = R.map((r) => [currentYear + (r%12 === 0 ? Math.floor(r/12) - 1 : Math.floor(r/12)), r%12 == 0 ? 12 : r%12], months)

	const urls = R.map((r) => {
	    return "https://www.airbnb.nl/api/v2/calendar_months?_format=with_conditions&count=1" +
	    "&listing_id=" + id.toString() + 
	    "&month=" + r[1] + 
	    "&year=" + r[0] +
	    "&key=d306zoyjsyarp7ifhu67rjxn52tv0t20&currency=EUR&locale=nl"     
	  }, values);

	return urls;
}

module.exports = getBookingUrls;