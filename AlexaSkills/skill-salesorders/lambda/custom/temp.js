const ServiceHelper = require('./modules/serviceHelper.js')


async function test()
{
    await ServiceHelper.callSAPCustomers("0307");    
    await ServiceHelper.callSAPCustomers("0307").then(
        (success) =>{
            console.log(success);
        })
    //console.log(res);
    //await ServiceHelper.callSAPCustomers("0307").then();
}
//test();


async function test2(){
    await ServiceHelper.callSAPCustomers('0307').then(        
        (serviceResult) =>{
            console.log(serviceResult);            
            let data = serviceResult;
            let customerCount = data.result.CustomerCount 
            if(customerCount== 1){
              speechText = 'Customer found ' +  data.result.Customers[0].CustomerName; 
            } else if (customerCount > 1){
              speechText = `Too many customers have been found. You can select one of the first  ${customerCount} Customers`; 
              for (let index = 0; index < customerCount; index++) {
                //const element = array[index];
                speechText += `Customer ${index} is ${data.result.Customers[index].CustomerName}`;  
              }
              speechText += 'Please just say the customer index, e.g. customer index 2, to select the second customer.';
            }
            console.log(speechText);
        })
        .catch((err) => {
            //set an optional error message here
            //outputSpeech = err.message;
            console.log(err);
            //console.log(data);
        });        
}

test2();

//ServiceHelper.callSAPCustomers("0307").then(console.log);
//ServiceHelper.callSAPMaterials("100-100").then(console.log);
//ServiceHelper.createSalesOrder("0000000307","100-100",5).then(console.log);


//callSAPCustomers2("0307", (error, data) => {console.log(data);});

//callSAPMaterials2("100", (error, data) => {console.log(data);});
//createSalesOrder("0000000307","100-100",5, (error, data) => {console.log(data);});
