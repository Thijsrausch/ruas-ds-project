const R = require('ramda');

const parseBookings = (bookingsJson) => {

  const bookings = bookingsJson.calendar_months[0];
  // console.log(JSON.stringify(bookings));


  const parsedBookings = R.map((r) => {
    return {
      available: r['available'],

      date: r['date'],
      available_for_checkin: r['available_for_checkin'],
      month_number: r['month'],
      price: r['price']['local_price']
    };
  }, bookings.days);

  return parsedBookings;
}

module.exports = parseBookings;