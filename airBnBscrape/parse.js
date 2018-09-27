const R = require('ramda');

const parse = (data) => {
  const listings = R.filter(R.has('listings'), data.explore_tabs[0].sections)[0].listings;

  const parsedListings = R.map((r) => {
    const listing = r.listing;
    const price = r.pricing_quote;

    // console.log(JSON.stringify(r));

    return {
      bathrooms: listing['bathrooms'],
      bedrooms: listing['bedrooms'],
      beds: listing['beds'],
      city: listing['city'],
      host_languages: listing['host_languages'],
      id: listing['id'],
      is_business_travel_ready: listing['is_business_travel_ready'],
      is_fully_refundable:listing['is_fully_refundable'],
      is_host_highly_rated:listing['is_host_highly_rated'],
      is_new_listing:listing['is_new_listing'],
      is_rebookable:listing['is_rebookable'],
      is_superhost:listing['is_superhost'],
      latitude: listing['lat'],
      longitude: listing['lng'],
      person_capacity: listing['person_capacity'],
      picture_count: listing['picture_count'],
      property_type_id: listing['property_type_id'],
      reviews_count: listing['reviews_count'],
      room_and_property_type: listing['room_and_property_type'],
      room_type_category: listing['room_type_category'],
      room_type: listing['room_type'],
      space_type: listing['space_type'],
      tier_id: listing['tier_id'],
      user_id: listing['user']['id'],
      amenity_ids: listing['amenity_ids'],

      price: price["rate"]["amount"],
      currency: price["rate"]["currency"],
      rate_type: price["rate_type"],

      price_with_service_fee: price["rate_with_service_fee"]["amount"],

    };
  }, listings);

  return parsedListings;
};

module.exports = parse;
