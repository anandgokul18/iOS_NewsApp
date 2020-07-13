var express = require("express");
var router = express.Router();

const axios = require('axios');
const moment = require('moment');
const headers = {
   "Ocp-Apim-Subscription-Key": "d901d64eeb334505825c20a547b760ba",
};

var result;

router.get("/", function (req, res, next) {
   let searchstring = req.query.searchstring.toString();
   console.log(searchstring);
   //let url = 'https://content.guardianapis.com/search?q=' + searchstring + '&api-key=aa7f1eea-628e-4444-b1d7-2a4175be8c1f&show-blocks=all';
   let url = 'https://api.cognitive.microsoft.com/bing/v7.0/suggestions?mkt=en-US&q=' + searchstring

   /*try {
      const response = await fetch(
         'https://api.cognitive.microsoft.com/bing/v7.0/suggestions?mkt=fr-FR&q=' + searchstring,
         {
            headers: {
               "Ocp-Apim-Subscription-Key": "d901d64eeb334505825c20a547b760ba"
            }
         }
      );
      const data = await response.json();
      const resultsRaw = data.suggestionGroups[0].searchSuggestions;
      const results = resultsRaw.map(result => ({ title: result.displayText, url: result.url }));
      this.setState({ results });


   } catch (error) {

      console.error(`Error fetching search ${value} `);
   }*/


   axios.get(encodeURI(url), { headers })
      .then(function (response) {
         // handle success
         //console.log(response);
         result = response.data;

         //Modifying Results so that iOS App doesn't have to struggle
         resultdict = {};
         resultdict.suggestions = [];

         let arrayOfSuggestions = result.suggestionGroups[0].searchSuggestions;

         for (index = 0; index < arrayOfSuggestions.length; index++) {
            resultdict.suggestions.push(arrayOfSuggestions[index].displayText);
         }

         result = resultdict

         res.send(result);
      })
      .catch(error => {
         console.log(error);
      });

});

module.exports = router;