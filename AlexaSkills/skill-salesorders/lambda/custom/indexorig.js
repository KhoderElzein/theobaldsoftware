/* eslint-disable  func-names */
/* eslint-disable  no-console */

const Alexa = require('ask-sdk-core');
//const intentHandlers = require('./modules/requestHandlers.js');
//const interceptors = require('./modules/interceptors.js');
const ServiceHelper = require('./modules/serviceHelper.js')

// INTENT HANDLERS  ================================================================================
const LaunchRequestHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'LaunchRequest';
    },
    handle(handlerInput) {
      const speechText = 'Welcome to the Alexa Skill to create SAP Sales Orders. To search a customer by number, just say e.g. search customer number 1000.'; 
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
  // customerinput as AMAZON.SearchQuery
  const SearchCustomerNumberIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && (handlerInput.requestEnvelope.request.intent.name === 'SearchCustomerNumberIntent' || handlerInput.requestEnvelope.request.intent.name === "AMAZON.StartOverIntent");
    },
    async handle(handlerInput) {
      let speechText = '';
      console.log("read slots: " + JSON.stringify(handlerInput.requestEnvelope.request.intent.slots)); 

      const customerinput = handlerInput.requestEnvelope.request.intent.slots.customerinput.value;
     
      await ServiceHelper.callSAPCustomers(customerinput).then(        
        (serviceResult) =>{
            //const data = JSON.parse(serviceResult);
            let data = serviceResult;
            // save customers to Sessionsattributes 
            let sessionAttributes = handlerInput.attributesManager.getSessionAttributes();
            sessionAttributes.customers = data.result;
            handlerInput.attributesManager.setSessionAttributes(sessionAttributes);
                      
            console.log("save session attributes: " + JSON.stringify(sessionAttributes));
           
            let customerCount = data.result.CustomerCount 
            if(customerCount== 1){
              speechText = 'Customer found ' +  data.result.Customers[0].CustomerName; 
            } else if (customerCount > 1){
              speechText = `Too many customers have been found. You can select one of the first  ${customerCount} Customers.` + '<break time="0.2s" />'; 
              let index = 0;
              for (index = 0; index < customerCount; index++) {
                speechText += `Number ${index+1} is ${data.result.Customers[index].CustomerName}.` + '<break time="0.2s" />';  
              }
              speechText += 'Please just say the customer index, e.g. customer index 2, to select the second customer.';
            }
            //console.log(success);
        })   
        .catch((error) => {
          //set an optional error message here
          speechText = error.message;
        });   
      return handlerInput.responseBuilder
        .speak(speechText)
        .withSimpleCard('Customer Result', speechText)
        .getResponse();
    },
  };
  
  // SelectcustomerindexIntent
  // selectedCustomerIndex AMAZON.NUMBER 1,2,3 
  const SelectCustomerIndexIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && handlerInput.requestEnvelope.request.intent.name === 'SelectCustomerIndexIntent';
    },
    handle(handlerInput) {
      let speechText = '';     
      /*
      speechText = 'Index dummy'; 
      return handlerInput.responseBuilder
        .speak(speechText)
        .reprompt(speechText)
        .withSimpleCard('SAP Sales Order', speechText)
        .getResponse(); 
        */     
          
      try { 
        if(handlerInput.requestEnvelope.request.intent.slots.selectedcustomerindex.value !== 'undefined')
          {
            console.log("read slots: " + JSON.stringify(handlerInput.requestEnvelope.request.intent.slots));
            let sessionAttributes = handlerInput.attributesManager.getSessionAttributes();
            console.log("read session attributes: " + JSON.stringify(sessionAttributes));
                        
            let selectedcustomerindex = handlerInput.requestEnvelope.request.intent.slots.selectedcustomerindex.value;            
            // save customers to Sessionsattributes 
            sessionAttributes.selectedcustomerindex = selectedcustomerindex;
            handlerInput.attributesManager.setSessionAttributes(sessionAttributes);

            let customers = sessionAttributes.customers.Customers;
            let customerCount = sessionAttributes.customers.CustomerCount;
            let selectedCustomerName = '';
            let selectedCustomerNumber = '';
            if( customers != null && selectedcustomerindex -1 <= customerCount){
              selectedCustomerName = customers[selectedcustomerindex -1].CustomerName;
              selectedCustomerNumber = customers[selectedcustomerindex -1].CustomerNumber;
              sessionAttributes.selectedCustomerName = selectedCustomerName;
              sessionAttributes.selectedCustomerNumber = selectedCustomerNumber;
              handlerInput.attributesManager.setSessionAttributes(sessionAttributes);
              speechText = 'Customer selected ' +  selectedCustomerName;             
              return handlerInput.responseBuilder
              .speak(speechText)
              .withSimpleCard('Customer successfully selected', speechText)
              .getResponse();
            } else {
              speechText = 'You should select the customer index at first'; 
              return handlerInput.responseBuilder
              .speak(speechText)
              //.repromt(speechText)
              .withSimpleCard('Customer not selected', speechText)
              .addElicitSlotDirective('selectedCustomerIndex')
              .getResponse();
            }    
        } else {
          speechText = 'Customer index not selected yet';  
          return handlerInput.responseBuilder
            .speak(speechText)
            .withSimpleCard('Error during selection', speechText)
            .getResponse();
        }                                                    
      }
      catch(error) {
        speechText = error.message;
        return handlerInput.responseBuilder
        .speak(speechText)
        .withSimpleCard('Customer Result', speechText)
        .getResponse();        
      }                        
    },
  };

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
  
  // GoodMorningIntentHandler
  const GoodMorningIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && handlerInput.requestEnvelope.request.intent.name === 'GoodMorningIntent';
    },
    handle(handlerInput) {
      const speechText = 'Good Morning!';
  
      return handlerInput.responseBuilder
        .speak(speechText)
        .withSimpleCard('Good Morning', speechText)
        .getResponse();
    },
  };
  
// GoodEveningIntentHandler
const GoodEveningIntentHandler = {
  canHandle(handlerInput) {
    return handlerInput.requestEnvelope.request.type === 'IntentRequest'
      && handlerInput.requestEnvelope.request.intent.name === 'GoodEveningIntent';
  },
  handle(handlerInput) {
    const speechText = 'Good Evening!';

    return handlerInput.responseBuilder
      .speak(speechText)
      .withSimpleCard('Good Evening', speechText)
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
  
  // The intent reflector is used for interaction model testing and debugging.
// It will simply repeat the intent the user said. You can create custom handlers
// for your intents by defining them above, then also adding them to the request
// handler chain below.
const IntentReflectorHandler = {
  canHandle(handlerInput) {
      return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest';
  },
  handle(handlerInput) {
      const intentName = Alexa.getIntentName(handlerInput.requestEnvelope);
      const speakOutput = `You just triggered ${intentName}`;

      return handlerInput.responseBuilder
          .speak(speakOutput)
          //.reprompt('add a reprompt if you want to keep the session open for the user to respond')
          .getResponse();
  }
};

  const UnhandledIntent = {
    canHandle() {
      return true;
    },
    handle(handlerInput) {
      return handlerInput.responseBuilder
        .speak("Error. No handler found for this intent")
        .reprompt("Error. No handler found for this intent")
        .getResponse();
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
    // this line end my research for the error reason, that took about 2 days
    console.log(`~~~~ Error handled: ${error.stack}`);    
    console.log(`~~~~ Error handled: ${JSON.stringify(error)}`);    
    console.log(`~~~~ Error handled: ${error.message}`);
    // Respond back to Alexa
    const speechText = "Global error. I'm sorry. Could you rephrase?";
    return handlerInput.responseBuilder
      .speak(speechText)
      .reprompt(speechText)
      .getResponse();
  },
};

// INTERCEPTORS ================================================================================

/**
 * Request Interceptor to log the request sent by Alexa
 */
const LogRequestInterceptor = {
  process(handlerInput) {
    // Log Request
    console.log("==== REQUEST ======");    
    // (x > 100) ? 1 : -1; 
    //var msg = handlerInput.requestEnvelope.request.intent.name || '';
    //var msg = (handlerInput.requestEnvelope.request.type === 'IntentRequest') ? handlerInput.requestEnvelope.request.intent.name : '';
    //console.log(msg);
    //console.log(" " + handlerInput.requestEnvelope.request.type + " " + msg);
    console.log("handlerInput.requestEnvelope.request.type: " + handlerInput.requestEnvelope.request.type);
    //console.log(`Handler Input: ${JSON.stringify(handlerInput)}`);
    console.log("handlerInput:\n"); 
    console.log(JSON.stringify(handlerInput, null, 2)); // for formatted JSON
    //console.log(JSON.stringify(handlerInput.requestEnvelope, null, 2)); // for formatted JSON
  }
};

/**
 * Response Interceptor to log the response made to Alexa
 */
const LogResponseInterceptor = {
  process(handlerInput, response) {
    // Log Response
    console.log("==== RESPONSE ======");
    console.log("handlerInput:\n");
    console.log(JSON.stringify(handlerInput, null, 2)); // for formatted JSON  
    console.log("sessionAttributes:\n");
    let sessionAttributes = handlerInput.attributesManager.getSessionAttributes(); 
    console.log(JSON.stringify(sessionAttributes, null, 2)); // for formatted JSON  
    console.log("response:\n");
    console.log(JSON.stringify(response, null, 2)); // for formatted JSON
  }
};        


// Export =====================================================================================
const skillBuilder = Alexa.SkillBuilders.custom();

/* LAMBDA SETUP */
exports.handler = skillBuilder
  .addRequestHandlers(
    LaunchRequestHandler,
    SearchCustomerNumberIntentHandler,
    SelectCustomerIndexIntentHandler,
    HelloWorldIntentHandler,
    GoodMorningIntentHandler,
    GoodEveningIntentHandler,
    HelpIntentHandler,
    CancelAndStopIntentHandler,
    SessionEndedRequestHandler,
    IntentReflectorHandler,
    UnhandledIntent
  )  
  .addRequestInterceptors(LogRequestInterceptor)
  .addResponseInterceptors(LogResponseInterceptor)
  .addErrorHandlers(GlobalErrorHandler)
  .lambda();
