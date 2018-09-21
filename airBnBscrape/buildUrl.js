const R = require('ramda');

const buildUrl = () => {
  const maxPrice = 500;
  const priceIncrement = 10;

  const priceList = R.addIndex(R.map)((r, i) => {
    return i*10;
  },R.repeat(1, maxPrice/priceIncrement));

  const urls = R.map((r) => {
    return "https://www.airbnb.nl/api/v2/explore_tabs?version=1.3.9&satori_version=1.0.7&_format=for_explore_search_web&experiences_per_grid=20&items_per_grid=18&guidebooks_per_grid=20&auto_ib=true&fetch_filters=true&has_zero_guest_treatment=false&is_guided_search=true&is_new_cards_experiment=true&luxury_pre_launch=false&query_understanding_enabled=true&show_groupings=true&supports_for_you_v3=true&timezone_offset=120&client_session_id=108d8de5-cc78-488b-b8a8-f1343853f504&metadata_only=false&is_standard_search=true&refinement_paths%5B%5D=%2Fhomes&selected_tab_id=home_tab&adults=1&children=0&infants=0&guests=1&click_referer=t%3ASEE_ALL%7Csid%3A51f2939f-a579-4ca2-b46e-d33110748380%7Cst%3AMAGAZINE_HOMES&allow_override%5B%5D=&" +
      "price_max="+(r+priceIncrement)+"&" +
      "price_min="+r+"&" +
      "federated_search_session_id=84a5849c-5648-423a-b4f8-3de4033bdc89&screen_size=medium&query=Rotterdam&_intents=p1&key=d306zoyjsyarp7ifhu67rjxn52tv0t20&currency=EUR&locale=nl"
  }, priceList);

  // this is for listing over 500 money witch is not include in the first sweep.
  // todo: examen if this captures all expensive listings
  const maxPriceUrl = "https://www.airbnb.nl/api/v2/explore_tabs?version=1.3.9&satori_version=1.0.7&_format=for_explore_search_web&experiences_per_grid=20&items_per_grid=18&guidebooks_per_grid=20&auto_ib=true&fetch_filters=true&has_zero_guest_treatment=false&is_guided_search=true&is_new_cards_experiment=true&luxury_pre_launch=false&query_understanding_enabled=true&show_groupings=true&supports_for_you_v3=true&timezone_offset=120&client_session_id=108d8de5-cc78-488b-b8a8-f1343853f504&metadata_only=false&is_standard_search=true&refinement_paths%5B%5D=%2Fhomes&selected_tab_id=home_tab&adults=1&children=0&infants=0&guests=1&click_referer=t%3ASEE_ALL%7Csid%3A51f2939f-a579-4ca2-b46e-d33110748380%7Cst%3AMAGAZINE_HOMES&allow_override%5B%5D=&price_min=500&federated_search_session_id=84a5849c-5648-423a-b4f8-3de4033bdc89&screen_size=medium&query=Rotterdam&_intents=p1&key=d306zoyjsyarp7ifhu67rjxn52tv0t20&currency=EUR&locale=nl";

  return R.concat(urls, [maxPriceUrl] )
};

module.exports = buildUrl;
