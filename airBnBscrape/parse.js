const R = require('ramda');

const parse = (data) => {
  const listings = R.filter(R.has('listings'), data.explore_tabs[0].sections)[0].listings;

  const parsedListings = R.map((r) => {
    const listing = r.listing;
    const price = r.pricing_quote;

    console.log(JSON.stringify(r));

    return {
      room_type: listing['room_type'],
      host_id: listing['user']['id'],
      address: listing['public_address'],
      reviews: listing['reviews_count'],
      overall_satisfaction: listing['star_rating'],
      accommodates: listing['person_capacity'],
      bedrooms: listing['bedrooms'],
      bathrooms: listing['bathrooms'],
      latitude: listing['lat'],
      longitude: listing['lng'],
      coworker_hosted: listing["coworker_hosted"],
      name: listing['name'],
      property_type: listing["property_type"],

      price: price["rate"]["amount"],
      currency: price["rate"]["currency"],
      rate_type: price["rate_type"]
    };
  }, listings);

  console.log(parsedListings);
};

module.exports = parse;
