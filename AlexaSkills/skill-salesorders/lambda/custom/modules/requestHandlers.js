//const constants = require('./constants');
//const logHelper = require('./logHelper'); 
const ServiceHelper = require('./serviceHelper.js')

const LaunchRequestHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'LaunchRequest';
    },
    handle(handlerInput) {
      const speechText = 'Welcome to the Alexa Skill to create SAP Sales Orders. To select a customer by number, just say e.g. customer number 1000.'; 
      return handlerInput.responseBuilder
        .speak(speechText)
        .reprompt(speechText)
        .withSimpleCard('SAP Sales Order', speechText)
        .getResponse();
    },
  };
  
  /*
  {
    "result": {
        "Customers": [
            {
                "CustomerNumber": "0000000307",
                "CustomerName": "Los Pollos Hermanos Inc"
            },
            {
                "CustomerNumber": "0000003070",
                "CustomerName": "William G. Smith MD"
            },
            {
                "CustomerNumber": "0000003071",
                "CustomerName": "Walter G. Baldwin"
            }
        ],
        "CustomerCount": "3"
    },
    "error": null
}
  */
  // SearchCustomernumberIntent
  // customerinput as AMAZON.NUMBER
  const SearchCustomernumberIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && handlerInput.requestEnvelope.request.intent.name === 'SearchCustomernumberIntent';
    },
    async handle(handlerInput) {
      let speechText = '';
      const customerinput = requestEnvelope.request.intent.slots.customerinput.value;
      await ServiceHelper.callSAPCustomers(customerinput).then(        
        (serviceResult) =>{
            const data = JSON.parse(serviceResult);
            let customerCount = data.result.CustomerCount 
            if(customerCount== 1){
              speechText = 'Customer found ' +  data.result.Customers[0].CustomerName; 
            } else if (customerCount > 1){
              speechText = `Too many customers have been found. You can select one of the first  ${customerCount} Customers`; 
              for (let index = 0; index < customerCount; index++) {
                const element = array[index];
                speechText += `Customer ${index} is ${data.result.Customers[index].CustomerName}`;  
              }
              speechText += 'Please just say the customer index, e.g. customer index 2, to select the second customer.';
            }
            //console.log(success);
        })      
      return handlerInput.responseBuilder
        .speak(speechText)
        .withSimpleCard('Customer Result', speechText)
        .getResponse();
    },
  };
  
  // SelectcustomerindexIntent
  // selectedCustomerIndex AMAZON.NUMBER 1,2,3 
  
  /*
{
    "result": {
        "Materials": [
            {
                "MaterialNumber": "100-100",
                "MaterialName": "Casings"
            },
            {
                "MaterialNumber": "A-100-100",
                "MaterialName": "Casings"
            },
            {
                "MaterialNumber": "BPM-100-1000",
                "MaterialName": "Tyre BPM-100-1000"
            }
        ],
        "MaterialCount": "3"
    },
    "error": null
}
  */
  // SearchMaterialnumberIntent 
  // materialinput as AMAZON.NUMBER 
  
  // SelectmaterialindexIntent
  // selectedMaterialIndex as AMAZON.NUMBER 1,2,3 
  
  // CreateSalesOrderIntent
  // quantity NUMBER
  
  // HelloWorldIntentHandler
  const HelloWorldIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && handlerInput.requestEnvelope.request.intent.name === 'HelloWorldIntent';
    },
    handle(handlerInput) {
      const speechText = 'Hello World!';
  
      return handlerInput.responseBuilder
        .speak(speechText)
        .withSimpleCard('Hello World', speechText)
        .getResponse();
    },
  };
  
  const HelpIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && handlerInput.requestEnvelope.request.intent.name === 'AMAZON.HelpIntent';
    },
    handle(handlerInput) {
      const speechText = 'You can say hello to me!';
  
      return handlerInput.responseBuilder
        .speak(speechText)
        .reprompt(speechText)
        .withSimpleCard('Hello World', speechText)
        .getResponse();
    },
  };
  
  const CancelAndStopIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && (handlerInput.requestEnvelope.request.intent.name === 'AMAZON.CancelIntent'
          || handlerInput.requestEnvelope.request.intent.name === 'AMAZON.StopIntent');
    },
    handle(handlerInput) {
      const speechText = 'Goodbye!';
  
      return handlerInput.responseBuilder
        .speak(speechText)
        .withSimpleCard('Hello World', speechText)
        .getResponse();
    },
  };
  
  const SessionEndedRequestHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'SessionEndedRequest';
    },
    handle(handlerInput) {
      console.log("==== SESSION ENDED WITH REASON ======");
      console.log(`Session ended with reason: ${handlerInput.requestEnvelope.request.reason}`);
  
      return handlerInput.responseBuilder.getResponse();
    },
  };
  
    
/**
 * Handler to catch exceptions from RequestHandler 
 * and respond back to Alexa
 * https://developer.amazon.com/de/blogs/alexa/post/71ac4c05-9e33-41d2-abbf-472ba66126cb/3-tips-to-troubleshoot-your-custom-alexa-skill-s-back-end
 */
const GlobalErrorHandler = {
  canHandle(handlerInput, error) {
    // handle all type of exceptions
    // Note : To filter on certain type of exceptions use error.type property
    return true;
  },
  handle(handlerInput, error) {
    // Log Error
    console.log("==== ERROR ======");
    //console.log(error);
    console.log(`Error handled: ${error.message}`);
    // Respond back to Alexa
    const speechText = "I'm sorry, I didn't catch that. Could you rephrase ?";
    return handlerInput.responseBuilder
      .speak(speechText)
      .reprompt(speechText)
      .getResponse();
  },
};

