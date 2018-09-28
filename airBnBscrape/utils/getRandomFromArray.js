const getRandomFromArray = (arr) => {
  const min = 0;
  const max = arr.length -1;

  const random = Math.floor(Math.random() * (max - min + 1)) + min;

  return arr[random];
} ;

module.exports = getRandomFromArray;
