const https = require('https');
const url = require('url'); 
const settings = require('./settings.json');

const ServiceHelper = {
    /*
    host = settings.RESTService.host,
    customerPath = settings.RESTService.customerPath,
    materialPath = settings.RESTService.materialPath,
    salesOrderPath = settings.RESTService.salesOrderPath,
    apiKey = settings.RESTService.apiKey,
    */
};

const host = settings.RESTService.host;
const customerPath = settings.RESTService.customerPath;
const materialPath = settings.RESTService.materialPath;
const salesOrderPath = settings.RESTService.salesOrderPath;
const apiKey = settings.RESTService.apiKey; 


ServiceHelper.callHTTPService = function(path,reqParam){
    var endPointUrl = host + path + reqParam;
    return new Promise(((resolve, reject)=> {
        var options = {
            host: url.parse(endPointUrl).hostname,
            port: url.parse(endPointUrl).port,
            path: url.parse(endPointUrl).path,
            method: "POST",        
            headers:{
                'Authorization':'APIKEY ' + apiKey,
                'Content-Type':'application/json',
                'Accept':'application/json'
            }
          };      
          var request = https.request(options, (response) => {
              response.setEncoding('utf8');
              var returnData = "";               
              response.on('data', (chunk) => {
                returnData += chunk;
              });
              response.on('end', () => {
                resolve(JSON.parse(returnData));                
              });
          });      
          request.on('error', (error) => {
            reject(error);
          });
          request.end();
        }));
    }

ServiceHelper.callSAPCustomers = function (reqParam){    
    try{
        return ServiceHelper.callHTTPService(customerPath,reqParam);
        //console.log(result);
    }
    catch(exception)
    {
        console.log(exception);
    }
}
    
ServiceHelper.callSAPMaterials =  function (reqParam){    
    try{
        return ServiceHelper.callHTTPService(materialPath,reqParam);
        //console.log(result);
    }
    catch(exception)
    {
        console.log(exception);
    }
}

// SoldToParty=307&ShipToParty=307&SalesOrganization=1000&DistributionChannel=10&Division=00&Material=100-100&Quantity=5 
ServiceHelper.createSalesOrder = function(customer,material,quantity){    
    var reqParam = 'SoldToParty=' + customer + '&ShipToParty=' + customer + '&SalesOrganization=1000&DistributionChannel=10&Division=00&Material=' + material + '&Quantity=' + quantity;
    try{
        return ServiceHelper.callHTTPService(salesOrderPath,reqParam);
        //console.log(result);
    }
    catch(exception)
    {
        console.log(exception);
    }
}

module.exports = ServiceHelper;