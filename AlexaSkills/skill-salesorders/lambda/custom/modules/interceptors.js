
/**
 * Request Interceptor to log the request sent by Alexa
 */
const LogRequestInterceptor = {
    process(handlerInput) {
      // Log Request
      console.log("==== REQUEST ======");
      console.log(JSON.stringify(handlerInput.requestEnvelope, null, 2));
    }
  }
  /**
   * Response Interceptor to log the response made to Alexa
   */
  const LogResponseInterceptor = {
    process(handlerInput, response) {
      // Log Response
      console.log("==== RESPONSE ======");
      console.log(JSON.stringify(response, null, 2));
    }
  }        