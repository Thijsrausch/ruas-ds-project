const fs = require('fs');


const writeFile = (data) => {
  try{  fs.mkdirSync('./generated/');} catch(err){
    console.error("I think the directory already exists");
    // console.error(err);
  }
  fs.writeFileSync('./generated/data.json', JSON.stringify(data));

};

module.exports = writeFile;
