/* eslint-disable  func-names */
/* eslint-disable  no-console */
//const Alexa = require('ask-sdk');
const Alexa = require('ask-sdk-core');
//const intentHandlers = require('./modules/requestHandlers.js');
//const interceptors = require('./modules/interceptors.js');
const ServiceHelper = require('./modules/serviceHelper.js')

const Messages = {
  Welcome : 'Welcome to the Alexa Skill to create SAP Sales Orders. To search a customer by number, just say e.g. search customer 1000.',
  SearchCustomer : 'To search a customer by number, just say e.g. search customer 1000.',
  SearchMaterial : 'To search a material by number, just say e.g. search material 100-100.',
  SelectCustomer : 'To select a customer just say the customer option, e.g. customer option 2, to select the second customer.',
  SelectMaterial : 'To select a material just say the material option, e.g. material option 2, to select the second material.',
  SetQuantity : 'Please set the quantity, e.g. quantity 5.'
}
// INTENT HANDLERS  ================================================================================
const LaunchRequestHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'LaunchRequest';
    },
    handle(handlerInput) {
      const speechText = Messages.Welcome; 
      let resp = handlerInput.responseBuilder
        .speak(speechText)
        .reprompt(speechText)
        .withSimpleCard('SAP Sales Order', speechText)
        .getResponse();
        return resp;
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
      let repromptText = Messages.SelectCustomer;
      console.log("read slots: " + JSON.stringify(handlerInput.requestEnvelope.request.intent.slots)); 

      const customerinput = handlerInput.requestEnvelope.request.intent.slots.customerinput.value;
     
      try {
        //Call the progressive response service
        let message = "OK, please wait while I look up for the customer";
        // await callDirectiveService(handlerInput, message);
  
      } catch (err) {
        // if it failed we can continue, just the user will wait longer for first response
        console.log("error : " + err.message);
        console.log("error : " + err.stack);
      }
     // shouldn't go longer than 5 seconds else lambda might time out
     await sleep(5000);

      await ServiceHelper.callSAPCustomers(customerinput).then(        
        (serviceResult) =>{
            //const data = JSON.parse(serviceResult);
            let data = serviceResult;
            // save customers to Sessionsattributes 
            let sessionAttributes = handlerInput.attributesManager.getSessionAttributes();
            sessionAttributes.customerResult = data.result;
            handlerInput.attributesManager.setSessionAttributes(sessionAttributes);
                      
            console.log("save session attributes: " + JSON.stringify(sessionAttributes));
           
            let customerCount = data.result.CustomerCount; 
            if(customerCount== 0){
              speechText = `No result found. ` + Messages.SearchCustomer; 
            } else if(customerCount== 1){
              speechText = `Customer found ${data.result.Customers[0].CustomerName} with number ${data.result.Customers[0].CustomerNumber.replace(/^0+/, '')}`; 
              speechText += Messages.SearchMaterial;
              repromptText = Messages.SearchMaterial;
            } else if (customerCount > 1){
              speechText = `Too many customers have been found. You can select one of the first ${customerCount} Customers.` + '<break time="0.2s" />'; 
              let index = 0;
              for (index = 0; index < customerCount; index++) {
                speechText += `Option ${index+1} is ${data.result.Customers[index].CustomerName}  with number ${data.result.Customers[index].CustomerNumber.replace(/^0+/, '')}.` + '<break time="0.2s" />';  
              }
              speechText += repromptText;
            }
            //console.log(success);
        })   
        .catch((error) => {
          //set an optional error message here
          speechText = error.message;
        });   
      return handlerInput.responseBuilder
        .speak(speechText)
        .reprompt(Messages.SelectCustomer)
        //.withShouldEndSession(true)
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
      let repromptText = Messages.SearchMaterial;
      let speechTitle  = 'Customers';
      /*
      speechText = 'Index dummy'; 
      return handlerInput.responseBuilder
        .speak(speechText)
        .reprompt(speechText)
        .withSimpleCard('SAP Sales Order', speechText)
        .getResponse(); 
         */
      
      let resp = handlerInput.responseBuilder;   
      try {
        console.log("read slots: " + JSON.stringify(handlerInput.requestEnvelope.request.intent.slots)); 
        if(handlerInput.requestEnvelope.request.intent.slots.selectedcustomerindex.value !== 'undefined')
          {            
            let selectedcustomerindex = handlerInput.requestEnvelope.request.intent.slots.selectedcustomerindex.value;            

            let sessionAttributes = handlerInput.attributesManager.getSessionAttributes();
            console.log("read session attributes: " + JSON.stringify(sessionAttributes));
                   
            
            // save customers to Sessionsattributes 
            sessionAttributes.selectedcustomerindex = selectedcustomerindex;
            handlerInput.attributesManager.setSessionAttributes(sessionAttributes);

            let sessionCustomers = sessionAttributes.customerResult;
            if(sessionCustomers === 'undefined'){
              speechText = 'Session Customers are undefined';
            }
            let customers = sessionCustomers.Customers;
            if(customers === 'undefined'){
              speechText = 'Customers are undefined in the attribute sessions';
            }
            let customerCount = sessionCustomers.CustomerCount;
            if(customerCount === 'undefined'){
              speechText = 'customerCount not found in the attribute sessions';
            }
            let selectedCustomerName = '';
            let selectedCustomerNumber = '';
            if( customers != null && selectedcustomerindex -1 <= customerCount){
              selectedCustomerName = customers[selectedcustomerindex -1].CustomerName;
              selectedCustomerNumber = customers[selectedcustomerindex -1].CustomerNumber;
              sessionAttributes.selectedCustomerName = selectedCustomerName;
              sessionAttributes.selectedCustomerNumber = selectedCustomerNumber;
              handlerInput.attributesManager.setSessionAttributes(sessionAttributes);              
              speechText = `Customer selected ${selectedCustomerName} with number ${selectedCustomerNumber.replace(/^0+/, '')}. ` + '<break time="0.2s" />';                
              speechText += repromptText;
              //resp.speak(speechText)
              //.withSimpleCard(speechTitle, speechText);
            } else {
              speechText = 'Not able to find the customer option';               
              //resp.speak(speechText)
              //.repromt(speechText)
              //.withSimpleCard(speechTitle, speechText)
              //.addElicitSlotDirective('selectedCustomerIndex');              
            }    
        } else {
          speechText = 'Customer option not selected yet';  
          //resp.speak(speechText).withSimpleCard(speechTitle, speechText);          
        }      
        resp.speak(speechText)
        .reprompt(repromptText)
        .withSimpleCard(speechTitle, speechText);                  
        return resp.getResponse();                                       
      }
      catch(error) {
        speechText = error.message;
        resp.speak(speechText)      
        .withSimpleCard(speechTitle, speechText);  
        return resp.getResponse();      
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
  // SearchMaterialNumberIntent 
  // materialinput as AMAZON.SearchQuery 
  const SearchMaterialNumberIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && handlerInput.requestEnvelope.request.intent.name === 'SearchMaterialNumberIntent';
    },
    async handle(handlerInput) {
      let speechText = '';
      let repromptText = Messages.SelectMaterial;
      console.log("read slots: " + JSON.stringify(handlerInput.requestEnvelope.request.intent.slots)); 
      const input = handlerInput.requestEnvelope.request.intent.slots.materialinput.value;
     
      try {
        //Call the progressive response service
        let message = "OK, please wait while I look up for the material";
        // await callDirectiveService(handlerInput, message);
  
      } catch (err) {
        // if it failed we can continue, just the user will wait longer for first response
        console.log("error : " + err.message);
        console.log("error : " + err.stack);
      }
     // shouldn't go longer than 5 seconds else lambda might time out
     await sleep(5000);

      await ServiceHelper.callSAPMaterials(input).then(        
        (serviceResult) =>{
            //const data = JSON.parse(serviceResult);
            let data = serviceResult;
            // save customers to Sessionsattributes 
            let sessionAttributes = handlerInput.attributesManager.getSessionAttributes();
            sessionAttributes.materialResult = data.result;
            handlerInput.attributesManager.setSessionAttributes(sessionAttributes);
                      
            console.log("save session attributes: " + JSON.stringify(sessionAttributes));
           
            let count = data.result.MaterialCount; 
            if(count== 0){
              speechText = `No result found. ` + Messages.SearchMaterial; 
            } else if(count== 1){
              speechText = `Material found ${data.result.Materials[0].MaterialName} with number ${data.result.Materials[0].MaterialNumber.replace(/^0+/, '')}`; 
            } else if (count > 1){
              speechText = `Too many materials have been found. You can select one of the first ${count} Materials.` + '<break time="0.2s" />'; 
              let index = 0;
              for (index = 0; index < count; index++) {
                speechText += `Option ${index+1} is ${data.result.Materials[index].MaterialName} with ${data.result.Materials[index].MaterialNumber.replace(/^0+/, '')}.` + '<break time="0.2s" />';  
              }
              speechText += repromptText;
            }
            //console.log(success);
        })   
        .catch((error) => {
          //set an optional error message here
          speechText = error.message;
        });   
      return handlerInput.responseBuilder
        .speak(speechText)
        .reprompt(repromptText)
        //.withShouldEndSession(true)
        .withSimpleCard('Material', speechText)
        .getResponse();
    },
  };


  // SelectMaterialIndexIntent
  // selectedmaterialindex as AMAZON.NUMBER 1,2,3 
  const SelectMaterialIndexIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && handlerInput.requestEnvelope.request.intent.name === 'SelectMaterialIndexIntent';
    },
    handle(handlerInput) {
      let speechText = '';  
      let repromptText = Messages.SelectMaterial;  
      let speechTitle  = 'Material';
      
      let resp = handlerInput.responseBuilder;   
      try {
        console.log("read slots: " + JSON.stringify(handlerInput.requestEnvelope.request.intent.slots)); 
        if(handlerInput.requestEnvelope.request.intent.slots.selectedmaterialindex.value !== 'undefined')
          {            
            let selectedmaterialindex = handlerInput.requestEnvelope.request.intent.slots.selectedmaterialindex.value;            
            let sessionAttributes = handlerInput.attributesManager.getSessionAttributes();
            console.log("read session attributes: " + JSON.stringify(sessionAttributes));                   
          
            // save to Sessionsattributes 
            sessionAttributes.selectedmaterialindex = selectedmaterialindex;
            handlerInput.attributesManager.setSessionAttributes(sessionAttributes);

            let sessionMaterials = sessionAttributes.materialResult;
            if(sessionMaterials === 'undefined'){
              speechText = 'Session Materials are undefined';
            }
            let materials = sessionMaterials.Materials;
            if(materials === 'undefined'){
              speechText = 'Materials are undefined in the attribute sessions';
            }
            let materialCount = sessionMaterials.MaterialCount;
            if(materialCount === 'undefined'){
              speechText = 'materialCount not found in the attribute sessions';
            }
            let selectedMaterialName = '';
            let selectedMaterialNumber = '';
            if( materials != null && selectedmaterialindex -1 <= materialCount){
              selectedMaterialName = materials[selectedmaterialindex -1].MaterialName;
              selectedMaterialNumber = materials[selectedmaterialindex -1].MaterialNumber;
              sessionAttributes.selectedMaterialName = selectedMaterialName;
              sessionAttributes.selectedMaterialNumber = selectedMaterialNumber;
              handlerInput.attributesManager.setSessionAttributes(sessionAttributes);              
              speechText = `Ok.You have selected Material ${selectedMaterialName} with number  ${selectedMaterialNumber.replace(/^0+/, '')}. `;  
              speechText += Messages.SetQuantity;
              //resp.speak(speechText)
              //.withSimpleCard(speechTitle, speechText);
            } else {
              speechText = 'Not able to find the material index'; 
              //resp.speak(speechText)
              //.repromt(speechText)
              //.withSimpleCard(speechTitle, speechText)
              //.addElicitSlotDirective('selectedmaterialIndex');              
            }    
        } else {
          speechText = 'material option not selected yet';  
          //resp.speak(speechText).withSimpleCard(speechTitle, speechText);          
        }      
        resp.speak(speechText)
        .reprompt(Messages.SetQuantity)
        .withSimpleCard(speechTitle, speechText);                  
        return resp.getResponse();                                       
      }
      catch(error) {
        speechText = error.message;
        resp.speak(speechText)      
        .withSimpleCard(speechTitle, speechText);  
        return resp.getResponse();      
      }  
                         
    },
  };


  /*
  {
    "result": {
        "ReturnTable": [
            {
                "ReturnMessageType": "S",
                "ReturnMessage": "SALES_HEADER_IN has been processed successfully",
                "ReturnNumber": "233",
                "ReturnID": "V4",
                "ReturnText": "VBAKKOM"
            },
            {
                "ReturnMessageType": "S",
                "ReturnMessage": "SALES_ITEM_IN has been processed successfully",
                "ReturnNumber": "233",
                "ReturnID": "V4",
                "ReturnText": "VBAPKOM"
            },
            {
                "ReturnMessageType": "W",
                "ReturnMessage": "The sales document is not yet complete: Edit data",
                "ReturnNumber": "555",
                "ReturnID": "V1",
                "ReturnText": "VBAPKOM"
            },
            {
                "ReturnMessageType": "S",
                "ReturnMessage": "Standard Order 16023 has been saved",
                "ReturnNumber": "311",
                "ReturnID": "V1",
                "ReturnText": "Standard Order"
            }
        ],
        "SO_Number": "0000016023"
    },
    "error": null
}
  */
  // CreateSalesOrderIntent
  // quantity NUMBER
  const CreateSalesOrderIntentHandler = {
    canHandle(handlerInput) {
      return handlerInput.requestEnvelope.request.type === 'IntentRequest'
        && handlerInput.requestEnvelope.request.intent.name === 'CreateSalesOrderIntent';
    },
    async handle(handlerInput) {
      let speechText = '';
      let speechTitle = 'Sales Order';

      let resp = handlerInput.responseBuilder;   
      try {
        console.log("read slots: " + JSON.stringify(handlerInput.requestEnvelope.request.intent.slots)); 
        if(handlerInput.requestEnvelope.request.intent.slots.quantity.value !== 'undefined')
          {            
            let quantity = handlerInput.requestEnvelope.request.intent.slots.quantity.value;            
            let sessionAttributes = handlerInput.attributesManager.getSessionAttributes();
            console.log("read session attributes: " + JSON.stringify(sessionAttributes));                               
            // save to Sessionsattributes 
            sessionAttributes.quantity = quantity;
            handlerInput.attributesManager.setSessionAttributes(sessionAttributes);

            let material = sessionAttributes.selectedMaterialNumber;
            let customer = sessionAttributes.selectedCustomerNumber;
            if (customer === 'undefined') {
              speechText = 'Please define customer. ' + Messages.SearchCustomer;
            }
            if (material === 'undefined') {
              speechText = 'Please define material. ' + Messages.SearchMaterial;
            }
            if (quantity === 'undefined' || quantity < 0) {
              speechText = 'Please define the quantity. ' + Messages.SetQuantity;
            }
            
            if (customer !== 'undefined' && material !== 'undefined' && quantity !== 'undefined' && quantity > 0) {                          
              await ServiceHelper.createSalesOrder(customer,material,quantity).then(        
                (serviceResult) =>{ 
                  let data = serviceResult;
                  // save customers to Sessionsattributes                 
                  sessionAttributes.orderResult = data.result;
                  handlerInput.attributesManager.setSessionAttributes(sessionAttributes);
                  let soNumber = data.result.SO_Number; 
                  if(!data.result.error){
                  let soNumber = data.result.SO_Number; 
                  if (soNumber !== 'undefined'){
                    speechText = `Sales order created successfully in SAP with number ${soNumber.replace(/^0+/, '')}`; 
                  } else {
                    let errormessage = '';
                    for (let index = 0; index < data.result.ReturnTable.length; index++) {
                      if (data.result.ReturnTable[index].ReturnMessageType = 'E') {
                        errormessage = data.result.ReturnTable[index].ReturnMessage;                      
                      }                    
                    }
                    speechText = `Error occured while creating the sales order. ${errormessage}`; 
                    }                  
                  }
                }
              )
            }
          }
        }
        catch(error) {
          speechText = error.message;
          resp.speak(speechText)      
          .withSimpleCard(speechTitle, speechText);  
          return resp.getResponse();      
        }    
      return handlerInput.responseBuilder
        .speak(speechText)
        .reprompt(Messages.Welcome)
        .withSimpleCard(speechTitle, speechText)
        .getResponse();
    },
  };
  
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
      const speakOutput = `You just triggered ${intentName} but no handler has been found for it`;

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
    var msg = (handlerInput.requestEnvelope.request.type === 'IntentRequest') ? handlerInput.requestEnvelope.request.intent.name : '';
    console.log('Intent name: ' + msg);
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

// Helpers ======================================

function callDirectiveService(handlerInput, message) {
  // Call Alexa Directive Service.
  const requestEnvelope = handlerInput.requestEnvelope;
  const directiveServiceClient = handlerInput.serviceClientFactory.getDirectiveServiceClient();

  const requestId = requestEnvelope.request.requestId;
  const endpoint = requestEnvelope.context.System.apiEndpoint;
  const token = requestEnvelope.context.System.apiAccessToken;

  // build the progressive response directive
  const directive = {
    header: {
      requestId,
    },
    directive:{ 
        type:"VoicePlayer.Speak",
        //speech:"Space is a bit far way. Wait till I get back the information from ISS."
          speech: message
    },
  };
  // send directive
  return directiveServiceClient.enqueue(directive, endpoint, token);
}

function sleep(milliseconds) {
  return new Promise(resolve => setTimeout(resolve(), milliseconds));
 }

// Export =====================================================================================

//const skillBuilder = Alexa.SkillBuilders.custom();
/* LAMBDA SETUP */
/*
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
*/

const skillBuilder = Alexa.SkillBuilders.custom()
  .addRequestHandlers(
    LaunchRequestHandler,
    SearchCustomerNumberIntentHandler,
    SelectCustomerIndexIntentHandler,
    SearchMaterialNumberIntentHandler,
    SelectMaterialIndexIntentHandler,
    CreateSalesOrderIntentHandler,
    HelpIntentHandler,
    CancelAndStopIntentHandler,
    SessionEndedRequestHandler,
    IntentReflectorHandler,
    UnhandledIntent
  )  
  .addRequestInterceptors(LogRequestInterceptor)
  .addResponseInterceptors(LogResponseInterceptor)
  .addErrorHandlers(GlobalErrorHandler)
  //.withApiClient(new Alexa.DefaultApiClient());


const ENVIRONMENT = 'production';
let skill;

if (ENVIRONMENT === 'production') {  
  /* LAMBDA SETUP */
  exports.handler = skillBuilder.lambda();
} else {
  // Development environment - we are on our local node server
  const express = require('express');
  const bodyParser = require('body-parser');
  const app = express();
  app.use(bodyParser.json());
  app.post('/', function(req, res) {
    if (!skill) {
      skill = skillBuilder.create();
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