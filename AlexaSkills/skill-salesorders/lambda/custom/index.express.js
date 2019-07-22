/*
https://github.com/alexa/alexa-skills-kit-sdk-for-nodejs/issues/362
handle requests to the new ask-sdk on my local express development server. 
"ENVIRONMENT" comes from a environment variable. 
If it is set to "production", we are on aws lambda. If not, we are on my local environment and using express.
I'm not sure if it's a best practice - but it's working fine for me.
*/

const Alexa = require('ask-sdk');
// If it is set to "production", we are on aws lambda. 
// If not, we are on my local environment and using express.
const ENVIRONMENT = 'production';

let skill;

if (ENVIRONMENT === 'production') {

  exports.handler = async function (event, context) {
    if (!skill) {
      skill = Alexa.SkillBuilders.custom()
        .addRequestHandlers(
          HelloWorldHandler
        )
        .create();
    }
    return skill.invoke(event,context);
  }

} else {

  // Development environment - we are on our local node server
  const express = require('express');
  const bodyParser = require('body-parser');
  const app = express();

  app.use(bodyParser.json());
  app.post('/', function(req, res) {

    if (!skill) {

      skill = Alexa.SkillBuilders.custom()
        .addRequestHandlers(
          HelloWorldHandler
        )
        .create();

    }

    skill.invoke(req.body)
      .then(function(responseBody) {
        res.json(responseBody);
      })
      .catch(function(error) {
        console.log(error);
        res.status(500).send('Error during the request');
      });

  });

  app.listen(3000, function () {
    console.log('Development endpoint listening on port 3000!');
  });

}