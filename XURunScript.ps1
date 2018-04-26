# execute an Xtract Universal extraction using the command tool xu.exe in a powershell script
# 2>&1 redirects standard error (the 2) to the same place as standard output (the 1)
&'C:\Program Files\XtractUniversal\xu.exe' -s "localhost" -p "8065" -n "SAPSalesCube" 1>$null  2>&1 

# the extraction has a variable CalendarMonth that needs a value in the format YYYYMM, e.g. 201712
&'C:\Program Files\XtractUniversal\xu.exe' -s "localhost" -p "8065" -n "SAPSalesCube" -o CalendarMonth='200401' 1>$null 2>&1 

# set the path to the installation folder
$XUCmd = 'C:\Program Files\XtractUniversal\xu.exe'
# XU server & port 
$XUServer = "localhost"
$XUPort = "8065"
# extraction name
$XUExtraction = "SAPSalesCube"

# run an extraction 
&$XUCmd -s $XUServer -p $XUPort -n $XUExtraction 1>$null 2>&1 

# Setting Calendar month variable 
# the extraction has a variable CalendarMonth that needs a value in the format YYYYMM, e.g. 201712
$myCalendarMonth = (Get-Date -format "yyyyMM")

# run an extraction with one parameter
&$XUCmd -s $XUServer -p $XUPort -n $XUExtraction -o CalendarMonth=$myCalendarMonth 1>$null 2>&1 

# run an extraction with multiple parameters
&$XUCmd -s $XUServer -p $XUPort -n $XUExtraction -o CalendarMonth=$myCalendarMonth -o clearBuffer=true 1>$null 2>&1 

# Fuction to run an XU extraction 
Function XURun($XUCmd, $XUServer, $XUPort, $XUExtraction, $XUParameters)
{ 
    Try {
        $parameters =  $XUCmd + " " + $XUServer + " " +  $XUPort + " " +  $XUExtraction + " " +  $XUParameters

        if([string]::IsNullOrEmpty($XUParameters)){
            &$XUCmd -s $XUServer -p $XUPort -n $XUExtraction 1>$null 2>&1 
        } else {
            &$XUCmd -s $XUServer -p $XUPort -n $XUExtraction -o $XUParameters 1>$null 2>&1 
        }
        
        
        # check the last exit code
        # 0: successful
        # else unsuccessful
        if($LASTEXITCODE -eq 0) {     
                      
            write-host -f Green "The last command $parameters has been executed successfully "  (Get-Date)            

        } else {           

            write-host -f Red "The last execution for $parameters failed with error code $LASTEXITCODE!"  (Get-Date)
            Write-Host $errorMessage
        }                
    }
    Catch {

        write-host -f Red "Error running XU extraction!" + (Get-Date)  $_.Exception.Message
    }
} 

# define error message
$errorMessage = @'
If the command completes an operation successfully, it returns an exit code of zero (0).
In case of an error, it will return one of the following (http status) codes:
HTTP Statuscodes (e.g. 404 when the extraction does not exist)
1001    An undefined error occured
1002    Could not find the specified file       
1013    Invalid input data
1014    The number of arguments is invalid
1015    The parameter name is unknown
1016    The argument is not valid
1053    Something is wrong with your URL
1087    The parameter is invalid
 
check the online help for further information
http://help.theobald-software.com/Xtract-Universal-EN/default.aspx?pageid=run-from-a-command-line
'@
 

# run an extraction with multiple parameters
$XUParameters = "clearBuffer=True -o CalendarMonth=$myCalendarMonth"
$XUResult = XURun -XUCmd $XUCmd -XUServer $XUServer -XUPort $XUPort -XUExtraction $XUExtraction -XUParameters $XUParameters 



# Loop for a parameter
$Months = @("200401","200402","200403")
foreach($Month in $Months){    
    XURun -XUCmd $XUCmd -XUServer $XUServer -XUPort $XUPort -XUExtraction $XUExtraction -XUParameters CalendarMonth=$Month 
}


# Run multiple extractions in sequence
Function XURun-Multi ($XUCmd, $XUServer, $XUPort, $XUExtractions,$XUParameters){
    foreach($XUExtraction in $XUExtractions){
         XURun -XUCmd $XUCmd -XUServer $XUServer -XUPort $XUPort -XUExtraction $XUExtraction -XUParameters $XUParameters
    }
}

$XUExtractions = "SAPCustomers", "SAPPlants","PSSAPCustomers", "PSSAPPlants"
$XUResult = XURUN-Multi -XUCmd $XUCmd -XUServer $XUServer -XUPort $XUPort -XUExtractions $XUExtractions

# Run multiple Extractions using powershell workflow 
# https://docs.microsoft.com/en-us/system-center/sma/overview-powershell-workflows
# http://www.powershellmagazine.com/2012/11/14/powershell-workflows/
Workflow XURun-Parallel { param ($XUCmd, $XUServer, $XUPort, $XUExtractions, $XUParameters, $ThrottleLimit)

    foreach -parallel -throttlelimit $ThrottleLimit ($XUExtraction in $XUExtractions){   
    
        InlineScript{             
            if([string]::IsNullOrEmpty($XUParameters)){
               &$Using:XUCmd -s $Using:XUServer -p $Using:XUPort -n $Using:XUExtraction 1>$null 2>&1 
            } else {    
               &$Using:XUCmd -s $Using:XUServer -p $Using:XUPort -n $Using:XUExtraction -o $Using:XUParameters 1>$null 2>&1 
            }           
        }     
        
    }
}

# 4 parallel extractions
$ThrottleLimit = 4 
XURun-Parallel -XUCmd $XUCmd -XUServer $XUServer -XUPort $XUPort -XUExtractions $XUExtractions -XUParameters $XUParamters -ThrottleLimit $ThrottleLimit

# Run multiple Extractions using powershell workflow 
# https://docs.microsoft.com/en-us/system-center/sma/overview-powershell-workflows
# http://www.powershellmagazine.com/2012/11/14/powershell-workflows/
Workflow XURun-Parallel2{ param ($XUCmd, $XUServer, $XUPort, $XUExtractions, $XUParameters, $ThrottleLimit)

    foreach -parallel -throttlelimit $ThrottleLimit ($XUExtraction in $XUExtractions){   
    
        InlineScript{  
                   
          Try {
        $parameters =  $Using:XUCmd + " " + $Using:XUServer + " " +  $Using:XUPort + " " +  $Using:XUExtraction + " " +  $Using:XUParameters

        if([string]::IsNullOrEmpty($Using:XUParameters)){
            &$Using:XUCmd -s $Using:XUServer -p $Using:XUPort -n $Using:XUExtraction 1>$null 2>&1 
        } else {
            &$Using:XUCmd -s $Using:XUServer -p $Using:XUPort -n $Using:XUExtraction -o $Using:XUParameters 1>$null 2>&1 
        }
        
        
        # check the last exit code
        # 0: successful
        # else unsuccessful
        if($LASTEXITCODE -eq 0) {     
                      
            write-host -f Green "The last command $Using:parameters has been executed successfully "  (Get-Date)            

        } else {           

            write-host -f Red "The last execution for $Using:parameters failed with error code $LASTEXITCODE!"  (Get-Date)
            Write-Host $errorMessage
        }                
    }
    Catch {

        write-host -f Red "Error running XU extraction!" + (Get-Date)  $_.Exception.Message
    }          
        }     
        
    }
}

# 4 parallel extractions
$ThrottleLimit = 4 
XURun-Parallel2 -XUCmd $XUCmd -XUServer $XUServer -XUPort $XUPort -XUExtractions $XUExtractions -XUParameters $XUParamters -ThrottleLimit $ThrottleLimit



# Get list of extractions from repository 
Function XUGet-Extractions($XUServer, $XUPort){    
    $XUExtractions= (Invoke-WebRequest "http://$XUServer`:$XUPort").Content | ConvertFrom-CSV
    return $XUExtractions
}
$XUExtractions = XUGet-Extractions $XUServer $XUPort 

# Get Extraction Names from Repository 
Function XUGet-ExtractionNames($XUServer, $XUPort){    
    $XUExtractions = XUGet-Extractions $XUServer $XUPort 
    $XUExtractionNames = $XUExtractions | foreach { $_.Name } #| where{$_ -like "*PSSAP*"}    
    return $XUExtractionNames
}
$XUExtractionNames = XUGet-ExtractionNames $XUServer $XUPort

# run all the extractions in the list
XURun-Parallel2 -XUCmd $XUCmd -XUServer $XUServer -XUPort $XUPort -XUExtractions $XUExtractionNames 


# Get Log 
Function XUGet-Log($XUServer, $XUPort){
    $XUExtractionNames = XUGet-ExtractionNames $XUServer $XUPort
    $XULog = @{}
    foreach ($XUExtractName in $XUExtractionNames) {
        # concatenate URL
        $XUURL = "http://$XUServer`:$XUPort/log/?req_type=extraction&name=$XUExtractName"
        # get log, convert it to csv, sort by timestamp and select the newest log 
        $newestLog = (Invoke-WebRequest $XUURL).Content | ConvertFrom-CSV |  Sort-Object Timestamp | Select-Object -Last 1
        # chech log status
        Switch ($newestLog.StateDescr) {
        "FinishedNoErrors"{ write-host -f Green $XUExtractName $newestLog}
        "FinishedErrors" {write-host -f Red $XUExtractName $newestLog}
        "Running" {write-host -f Yellow $XUExtractName $newestLog}
        "NotAvailable"{write-host -f Blue $XUExtractName $newestLog}
        }
        $XULog.Add($XUExtractName, $newestLog)     
    }
    return $XULog
}
$XULog = XUGet-Log $XUServer $XUPort

# Get Metadata
# http://[host]:[port]/metadata/?name=[extractionName]
Function XUGet-Metadata($XUServer, $XUPort){
    $XUExtractionNames = XUGet-ExtractionNames $XUServer $XUPort
    $XUMetadata = @{}
    foreach ($XUExtractName in $XUExtractionNames) {
        # concatenate URL
        $XUURL = "http://$XUServer`:$XUPort/metadata/?name=$XUExtractName"
        # get log, convert it to csv, sort by timestamp and select the newest log 
        $tmpmeta = (Invoke-WebRequest $XUURL).Content | ConvertFrom-CSV 
        $XUMetadata.Add($XUExtractName, $tmpmeta)     
    }
    return $XUMetadata
}
$XUMetadata = XUGet-Metadata $XUServer $XUPort