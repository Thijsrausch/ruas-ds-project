const delay = (ms) => {
  console.log('waiting for ', ms, 'ms')
  return new Promise(resolve => {
    setTimeout(resolve, ms);
  });
};

module.exports = delay;
