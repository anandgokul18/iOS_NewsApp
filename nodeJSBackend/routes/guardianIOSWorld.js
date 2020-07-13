var express = require("express");
var router = express.Router();

const axios = require('axios');
const moment = require('moment');

var result;

router.get("/", function (req, res, next) {
   axios.get('https://content.guardianapis.com/world?api-key=aa7f1eea-628e-4444-b1d7-2a4175be8c1f&show-blocks=all')
      .then(function (response) {
         // handle success
         //console.log(response);
         result = response.data;

         //Modifying Results so that iOS App doesn't have to struggle
         let temp = {};
         temp.articles = [];
         for (let i = 0; i < 10; i++) {
            let currentItem = result.response.results[i];
            let newelement = {}

            newelement.headline = currentItem.webTitle;
            newelement.category = currentItem.sectionName;
            newelement.originalDate = currentItem.webPublicationDate;
            newelement.description = currentItem.blocks.body[0].bodyTextSummary;
            newelement.url = currentItem.webUrl;

            newelement.imageUrl = '';
            try {
               newelement.imageUrl = currentItem.blocks.main.elements[0].assets[currentItem.blocks.main.elements[0].assets.length - 1].file;
               //newelement.imageUrl = currentItem.blocks.main.elements[0].assets[0].file;
            } catch (e) {
               newelement.imageUrl = 'https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png';
            }

            let onlyDate = currentItem.webPublicationDate.substring(0, 10);
            newelement.expandedDate = moment(onlyDate, 'YYYY-MM-DD').format('DD MMMM YYYY');

            newelement.agoDate = moment(onlyDate, 'YYYY-MM-DD').fromNow();

            temp.articles.push(newelement);
         }

         result = temp;

         res.send(result);
      })
      .catch(error => {
         console.log(error);
      });

});

module.exports = router;