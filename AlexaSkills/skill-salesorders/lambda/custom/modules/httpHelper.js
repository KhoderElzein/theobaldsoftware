const querystring = require('querystring');
const https = require('https');

https://stackoverflow.com/questions/40537749/how-do-i-make-a-https-post-in-node-js-without-any-third-party-module
var postData = querystring.stringify({ 
    'Customer' : '0307!'
});


// https://ecscore.servicebus.windows.net/ecs/ws/custom/SalesOrderWebserviceAlexa/GetCustomer/?Customer=0307
var options = {
    hostname: 'ecscore.servicebus.windows.net',
    port: 80,
    path: '/ecs/ws/custom/SalesOrderWebserviceAlexa/GetCustomer/',
    method: 'POST',
    headers: {
         //'Content-Length': postData.length,
         'Authorization': 'APIKEY 0271D3E34DD04000ACDACBE75FAA52F9',
         'Content-Type' : 'application/json',
         'Accept':'application/json'
       }
  };
  
  // see city guide goout handler 
  /*
  const GoOutHandler = {
    canHandle(handlerInput) {
        const request = handlerInput.requestEnvelope.request;

        return request.type === 'IntentRequest' && request.intent.name === 'GoOutIntent';
    },
    handle(handlerInput) {
        return new Promise((resolve) => {
            getWeather((localTime, currentTemp, currentCondition) => {
                const speechOutput = `It is ${localTime
                } and the weather in ${data.city
                } is ${
                    currentTemp} and ${currentCondition}`;
                resolve(handlerInput.responseBuilder.speak(speechOutput).getResponse());
            });
        });
    },
};
  */
  function getWeather2(callback) {
    var req = https.request(options, (res) => {
        console.log('statusCode:', res.statusCode);
        console.log('headers:', res.headers);
        res.setEncoding('utf8'); 
        let returnData = ''; 
    
        res.on('data', (d) => {
          // process.stdout.write(d);
          returnData += chunk;
        });
        res.on('end', () => {
            const channelObj = JSON.parse(returnData).query.results.channel;
            let localTime = channelObj.lastBuildDate.toString();
            localTime = localTime.substring(17, 25).trim();
            const currentTemp = channelObj.item.condition.temp;
            const currentCondition = channelObj.item.condition.text;
            callback(localTime, currentTemp, currentCondition);
        });
      });
      
      req.on('error', (e) => {
        console.error(e);
      });
      
      req.write(postData);
      req.end();    
  }
  
  


// https://ecscore.servicebus.windows.net/ecs/ws/custom/SalesOrderWebserviceAlexa/GetCustomer/?Customer=0307
const myAPI = {
    host: 'query.yahooapis.com',
    port: 443,
    path: `/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22${encodeURIComponent(data.city)}%2C%20${data.state}%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys`,
    method: 'POST',
};

function getWeather(callback) {
    const req = https.request(myAPI, (res) => {
        res.setEncoding('utf8');
        let returnData = '';

        res.on('data', (chunk) => {
            returnData += chunk;
        });
        res.on('end', () => {
            const channelObj = JSON.parse(returnData).query.results.channel;

            let localTime = channelObj.lastBuildDate.toString();
            localTime = localTime.substring(17, 25).trim();

            const currentTemp = channelObj.item.condition.temp;

            const currentCondition = channelObj.item.condition.text;

            callback(localTime, currentTemp, currentCondition);
        });
    });
    req.end();
}
