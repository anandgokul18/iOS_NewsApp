var express = require("express");
var router = express.Router();

const axios = require('axios');
const googleTrends = require('google-trends-api');

var result;

router.get("/", function (req, res, next) {
   let searchstring = req.query.searchstring.toString();
   //console.log(searchstring);


   googleTrends.interestOverTime({ keyword: searchstring, startTime: new Date('2019-06-01') })
      .then(function (results) {
         //console.log(results);

         //Converting String to JS
         results = JSON.parse(results);

         let temp = {};
         temp.valueArray = [];

         timelineData = results["default"]["timelineData"];

         //console.log(timelineData);

         for (index = 0; index < timelineData.length; index++) {
            temp.valueArray.push(timelineData[index]["value"][0]);
         }

         console.log(temp);

         res.send(temp);
      })
      .catch(function (err) {
         console.error(err);
      });

});

module.exports = router;