
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


# Get list of extractions from repository 
Function XUGet-Extractions($XUServer, $XUPort){    
    $XUExtractions= (Invoke-WebRequest "http://$XUServer`:$XUPort").Content | ConvertFrom-CSV
    return $XUExtractions
}
#$XUExtractions = XUGet-Extractions $XUServer $XUPort 
#$XUExtractions | Select Name

# Get Extraction Names from Repository 
Function XUGet-ExtractionNames($XUServer, $XUPort){    
    $XUExtractions = XUGet-Extractions $XUServer $XUPort 
    $XUExtractionNames = $XUExtractions | foreach { $_.Name } #| where{$_ -like "*PSSAP*"}    
    return $XUExtractionNames
}
#$XUExtractionNames = XUGet-ExtractionNames $XUServer $XUPort


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
#$XULog = XUGet-Log $XUServer $XUPort


# Get Table Description From Name
# http://[host]:[port]/?name=GetTableDescription&TableName=TableName

Function XUGet-TableDescriptionFromName($XUServer, $XUPort, $TableName){
    # concatenate URL
    $XUURL = "http://$XUServer`:$XUPort/?name=GetTableDescription&TableName=$TableName"
    # get description, convert it to csv
    $XUTableDescription = (Invoke-WebRequest $XUURL).Content | ConvertFrom-CSV 
	# output
	#TABNAME,DDTEXT
	#MAKT,Material Descriptions
    return $XUTableDescription
}

# Get Table Description
# http://[host]:[port]/?name=GetTableDescription&TableName=TableName
# Name can have the form Table_Description_MAKT
Function XUGet-TableDescription($XUServer, $XUPort){
    $XUExtractionNames = XUGet-ExtractionNames $XUServer $XUPort
    $XUTableDescription= @{}
    foreach ($XUExtractName in $XUExtractionNames) {
        # concatenate URL
        $TableName=$($XUExtractName.Substring($XUExtractName.LastIndexOf('_')+1))
        # get description, convert it to csv
		$tmp = XUGet-TableDescriptionFromName $XUServer $XUPort $TableName
		if ($tmp -ne $null){
        	$XUTableDescription.Add($XUExtractName, $tmp)     
		}
    }
    return $XUTableDescription
}

# Get Table Description
# http://[host]:[port]/?name=GetTableDescription&TableName=TableName
# Name can have the form Table_Description_MAKT
Function XUGet-TableDescription2($XUServer, $XUPort){
    $XUExtractionNames = XUGet-ExtractionNames $XUServer $XUPort
    $XUTableDescription= @{}
    foreach ($XUExtractName in $XUExtractionNames) {
        # concatenate URL
        $XUURL = "http://$XUServer`:$XUPort/?name=GetTableDescription&TableName=$($XUExtractName.Substring($XUExtractName.LastIndexOf('_')+1))"
        # get description, convert it to csv
        $tmp = (Invoke-WebRequest $XUURL).Content | ConvertFrom-CSV 
		# output
		#TABNAME,DDTEXT
		#MAKT,Material Descriptions
		if ($tmp -ne $null){
        	$XUTableDescription.Add($XUExtractName, $tmp)     
		}
    }
    return $XUTableDescription
}
#clear


Function XUList-PerExtractionName($XUServer,$XUPort){
	$XUTableDescription = XUGet-TableDescription $XUServer $XUPort
	Write-Host "ExtractionName, TableName, TableDescription`n"
	foreach ($h in ($XUTableDescription.GetEnumerator() | Sort Key)) {        
		foreach ($h2 in $h.Value) {
		 Write-Host "$($h.Name), $($h2.TABNAME), $($h2.DDTEXT)"
		}	
	}
}


Function XUList-PerTableDescription($XUServer,$XUPort){
	Write-Host "TableDescription (TableName)`n"
	foreach ($h in ($XUTableDescription.GetEnumerator() | Sort Key)) {        
		foreach ($h2 in $h.Value) {
		 Write-Host "$($h2.DDTEXT) ($($h2.TABNAME))"
		}	
	}
}

# Get Metadata
# http://[host]:[port]/metadata/?name=[extractionName]
Function XUGet-MetadataPerExtraction($XUServer, $XUPort,$XUExtractionName){
   
	# concatenate URL
    $XUURL = "http://$XUServer`:$XUPort/metadata/?name=$XUExtractionName"
    # get log, convert it to csv, sort by timestamp and select the newest log 
    $XUMetadata = (Invoke-WebRequest $XUURL).Content | ConvertFrom-CSV 
	#output 
	#POSITION,NAME,DESC,TYPE,LENGTH,DECIMALS
	#0,Material_Number_MATNR,Material Number,C,18,0
	#1,Material_Text_MAKTX,Material Description (Short Text),C,40,0

	return $XUMetadata
}

# Get Metadata
# http://[host]:[port]/metadata/?name=[extractionName]
Function XUGet-Metadata($XUServer, $XUPort){
    $XUExtractionNames = XUGet-ExtractionNames $XUServer $XUPort
    $XUMetadata = @{}
    foreach ($XUExtractName in $XUExtractionNames) {
		$tmpmeta = XUGet-MetadataPerExtraction $XUServer $XUPort $XUExtractName
        $XUMetadata.Add($XUExtractName, $tmpmeta)     
    }
    return $XUMetadata
}


# Get Metadata
# http://[host]:[port]/metadata/?name=[extractionName]
Function XUGet-Metadata2($XUServer, $XUPort){
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

# $XUMetadata = XUGet-Metadata $XUServer $XUPort

# $XUMetadata[0].Keys | % { "key = $_ , value = " + $XUMetadata[0].Item($_) } 
clear 
Function XUList-Metadata($XUMetadata){
	Write-Host "TableName, ColumnPosition, ColumnName, ColumnDescription`n"
	foreach ($h in ($XUMetadata.GetEnumerator() | Sort Key)) {    
	    Write-Host "******** Begin $($h.Name) ********"
		foreach ($h2 in $h.Value) {
		 Write-Host "$($h.Name), $([int]$h2.Position+1), $($h2.NAME), $($h2.DESC)"
		}
		Write-Host "******** End  $($h.Name) ********`n"
		
	}
}