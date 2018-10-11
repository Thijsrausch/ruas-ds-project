const delay = (ms) => {
  console.log('waiting for ', Math.floor(ms / 1000), 's');
  return new Promise(resolve => {
    setTimeout(resolve, ms);
  });
};

module.exports = delay;
