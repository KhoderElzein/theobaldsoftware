Function Get-Lists($SPWebURL, $SPListName, $SPCredentials){

    Try {
        #Setup the context
        $SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)        
        $SPContext.Credentials = $SPCredentials
     
        #Get All Lists
        $Lists = $SPContext.Web.Lists
        $SPContext.Load($Lists)
        $SPContext.ExecuteQuery() 
        #Check if List doesn't exists already
        
        return $SPContext, $Lists
        }         
    Catch {
        write-host -f Red "Error Getting List '$SPListName'!" $_.Exception.Message
    }

}

Function Create-List($SPWebURL, $SPListName, $SPCredentials)
{ 
    Try {
        #Setup the context
        #$SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)        
        #$SPContext.Credentials = $SPCredentials
     
        #Get All Lists
        #$Lists = $SPContext.Web.Lists
        #$SPContext.Load($Lists)
        #$SPContext.ExecuteQuery() 
        $SPContext, $Lists = Get-Lists $SPWebURL $SPListName $SPCredentials

        #Check if List doesn't exists already
        if(!($Lists.Title -contains $SPListName))
        {
            #sharepoint online powershell create list
            $ListInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
            $ListInfo.Title = $SPListName
            $ListInfo.TemplateType = 100 #Custom List
            $List = $SPContext.Web.Lists.Add($ListInfo)
            #$List.Description = "Repository to store project artifacts"
            $List.Update()
            $SPContext.ExecuteQuery()
  
            write-host  -f Green "List '$SPListName' has been created!"
        }
        else
        {
            Write-Host -f Red "List '$SPListName' already exists!"
        }
    }
    Catch {
        write-host -f Red "Error Creating List!" $_.Exception.Message
    }


}

Function Delete-List($SPWebURL, $SPListName, $SPCredentials)
{ 
    Try {
        #Setup the context
        #$SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
        #$SPContext.Credentials = $SPCredentials
     
        #Get All Lists
        #$Lists = $SPContext.Web.Lists
        #$SPContext.Load($Lists)
        #$SPContext.ExecuteQuery() 

        $SPContext, $Lists = Get-Lists $SPWebURL $SPListName $SPCredentials
        #Check if List doesn't exists already
        if($Lists.Title -contains $SPListName)
        {
            #Get the List
            $List=$SPContext.Web.Lists.GetByTitle($SPListName)            
            $List.DeleteObject()
            $SPContext.ExecuteQuery()         
            Write-host -f Green "List '$SPListName' Deleted Successfully!"
        }
        else
        {
            Write-Host -f Red "List '$SPListName' does not exist!"
        }
    }
    Catch {
        write-host -f Red "Error Creating List!" $_.Exception.Message
    }


}

<#
Function Add-ViewField ($SPWebURL, $SPListName, $SPCredentials){
    Try {
     
        #$SPCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
 
        #Get Web information and subsites
        $SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
        $SPContext.Credentials = $SPCredentials
     
        #get the list
        $List = $SPContext.Web.Lists.GetByTitle($SPListName)
     
        #Check if View has the field already
        $ViewFields = $List.DefaultView.ViewFields
        # Get a specific list view by Name
        #$view=$List.Views.getByTitle($ViewName)
        $SPContext.load($ViewFields) 
        $SPContext.ExecuteQuery() 
 
        if( ($ViewFields -Contains $FieldToAdd) -eq $false) {
            #Add the Field to View
            $List.DefaultView.ViewFields.Add($FieldToAdd)
            $List.DefaultView.Update()
            $SPContext.ExecuteQuery()
 
            Write-host "Field '$FieldToAdd' Added to List View!" -ForegroundColor Green
        }
        else {
        write-host "Field exists in the view already!" -foregroundcolor Red
        }
 
    }
    catch {
        write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
    }
}
#>
<#
Function Remove-ViewField ($SPWebURL, $SPListName, $SPCredentials){
    Try {   
        #$SPCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
 
        #Setup the context
        $SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
        $SPContext.Credentials = $SPCredentials
     
        #get the list
        $List = $SPContext.Web.Lists.GetByTitle($SPListName)
     
        #Check if the View has the field in it
        $ViewFields = $List.DefaultView.ViewFields
        $SPContext.load($ViewFields) 
        $SPContext.ExecuteQuery() 
 
        if( ($ViewFields -Contains $FieldToAdd) -eq $true) {
            #Add the Field to View
            $List.DefaultView.ViewFields.Remove($FieldToAdd)
            $List.DefaultView.Update()
            $SPContext.ExecuteQuery()
 
            Write-host "Field Has been removed from the List View!" -ForegroundColor Green
        }
        else {
        write-host "Field doesn't exists in the view!" -foregroundcolor Red
        }
 
    }
    catch {
        write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
    }
}
#>
Function Delete-AllItems($SPWebURL,$SPListName,$SPCredentials){
    try {
        #Set up the context
        #$SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
        #$SPContext.Credentials = $SPCredentials

        $SPContext, $Lists = Get-Lists $SPWebURL $SPListName $SPCredentials

        if($Lists.Title -contains $SPListName)
        {
             #Get the List
            $List = $SPContext.Web.Lists.GetByTitle($SPListName)
            $ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
            $SPContext.Load($ListItems)
            $SPContext.ExecuteQuery()      
 
            write-host "Total Number of List Items found:"$ListItems.Count
 
            if ($ListItems.Count -gt 0)
            {
                #Loop through each item and delete
                For ($i = $ListItems.Count-1; $i -ge 0; $i--)
                {
                    $ListItems[$i].DeleteObject()
                }
                $SPContext.ExecuteQuery()
         
                Write-Host "All List Items deleted Successfully!" -foregroundcolor Green
            }           
  
            #write-host  -f Green "List '$SPListName' has been created!"
        }
        else
        {
            Write-Host -f Red "List '$SPListName' not found!"
        }   
    }
    catch {
        write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
    }
    
}

<#
Function Update-ItemById ($SPWebURL,$SPListName,$SPCredentials, $ID,$Title){

    try{
    
        #Setup the context
        $SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
        $SPContext.Credentials = $SPCredentials
     
        #get the list
        $List = $SPContext.Web.Lists.GetByTitle($SPListName)
   
        #Filter and Get the List Items using CAML
        #$List = $SPContext.web.Lists.GetByTitle($SPListName)
 
        #Get List Item by ID
        $ListItem = $List.GetItemById($ID) 
 
        #Update List Item title
        $ListItem["Title"] = $Title
        $ListItem.Update() 
 
        $SPContext.ExecuteQuery()
        write-host "Item Updated!"  -foregroundcolor Green 
    }
    catch{ 
        write-host "$($_.Exception.Message)" -foregroundcolor red 
    } 


#Read more: http://www.sharepointdiary.com/2015/07/sharepoint-online-update-list-items-using-powershell.html#ixzz5AqzMpAN5
}
#>

function Add-Fields($SPWebURL, $SPListName,$SPCredentials, $Columns) {

    
    #Setup the context
    #$SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
    #$SPContext.Credentials = $SPCredentials
     
    #Get All Lists
    #$Lists = $SPContext.Web.Lists
    #$SPContext.Load($Lists)
    #$SPContext.ExecuteQuery() 

    $SPContext, $Lists = Get-Lists $SPWebURL $SPListName $SPCredentials 

    #Check if List doesn't exists already
    if($Lists.Title -contains $SPListName)
    {   

        #Get the List
        $List = $SPContext.Web.Lists.GetByTitle($SPListName)
        $SPContext.Load($List)
        $SPContext.ExecuteQuery()

        $Fields = $List.Fields        
        $DefaultView = $List.DefaultView
        $ViewFields = $DefaultView.ViewFields
        $SPContext.Load($Fields)
        $SPContext.Load($DefaultView)
        $SPContext.Load($ViewFields)
        $SPContext.executeQuery()

        $TitleField = $Fields | where { ($_.Internalname -eq "Title") }
        if($TitleField -ne $NULL) 
        {
            $TitleField = $List.Fields.GetByInternalNameOrTitle("Title")
            #$TitleField = $List.Fields.GetById($TitleField[0].Id)
            $TitleField.Required = $false;                
        }
       
        #$ViewField = $ViewFields | where { ($_.Internalname -eq "LinkTitle") -or ($_.Title -eq "LinkTitle")}
        $ViewField = $ViewFields | where { ($_ -eq "LinkTitle")}
        if($ViewField -ne $NULL) 
        {
            $DefaultView.ViewFields.Remove("LinkTitle")              
        }
        $DefaultView.Update()
        $SPContext.ExecuteQuery()        
  
        if($Columns.Count -eq 0){
            write-host "Input parameter does not contain any fields" -foregroundcolor red 
        } else { 
        for ($i=0; $i -lt $Columns.Count; $i++) {         
            $FieldName = $Table.Columns[$i].ColumnName
            if(![string]::IsNullOrEmpty($FieldName)){
                $FieldType = "Text"                            
                #Add-ListField -WebURL $SPWebURL -ListName $SPListName -Credentials $SPCredentials -FieldType $FieldType -Name $FieldName -DisplayName $FieldName -Description $FieldName -IsRequired $false -EnforceUniqueValues $false                          
                #Generate new GUID for Field ID
                $FieldID = [guid]::NewGuid()      
                #Check if the column exists in list already
                $NewField = $Fields | where { ($_.Internalname -eq $FieldName) -or ($_.Title -eq $FieldName) }
                if($NewField -ne $NULL) 
                {
                    Write-host "Column '$FieldName' already exists in the List!" -f Yellow
                }
                else
                {
                    # template for number fields
                    #$FieldSchema = "<Field Type='Number' ID='{$FieldID}' DisplayName='$DisplayName' Name='$Name' Description='$Description' Required='$IsRequired' EnforceUniqueValues='$EnforceUniqueValues' />"
                    #$NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)

                    #Define XML for Field Schema
                    # MaxLength='$MaxLength' for Text
                    $FieldSchema = "<Field Type='$FieldType' ID='{$FieldID}' Name='$FieldName' StaticName='$FieldName' DisplayName='$FieldName' Description='$Description' Required='$IsRequired' EnforceUniqueValues='$EnforceUniqueValues' />" 
                    $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
                    $SPContext.ExecuteQuery()   

                    Write-host "Column '$FieldName' Added to the List Successfully!" -ForegroundColor Green 
                }

            }
             
        }
    
    }                          
    }else{
        write-host "List can not be accessed" -foregroundcolor red 
    }

}

#Custom function to add column to list
Function Add-ListField()
{
    param
    (
        [Parameter(Mandatory=$true)] [string] $SPWebURL,
        [Parameter(Mandatory=$true)] [string] $SPListName,
        $SPCredentials,
        [Parameter(Mandatory=$true)] [string] $FieldType,
        [Parameter(Mandatory=$true)] [string] $Name,
        [Parameter(Mandatory=$true)] [string] $DisplayName,
        [Parameter(Mandatory=$true)] [string] $Description,
        [Parameter(Mandatory=$true)] [string] $IsRequired,       
        [Parameter(Mandatory=$true)] [string] $EnforceUniqueValues        
    )
 
    #Generate new GUID for Field ID
    $FieldID = New-Guid
 
    Try {
 
        #Setup the context
        #$SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
        #$SPContext.Credentials = $SPCredentials
         
        #Get the List
        #$List = $SPContext.Web.Lists.GetByTitle($SPListName)
        #$SPContext.Load($List)
        #$SPContext.ExecuteQuery()
 
        $SPContext, $Lists = Get-Lists $SPWebURL $SPListName $SPCredentials
        #Check if the column exists in list already
        $Fields = $List.Fields
        $SPContext.Load($Fields)
        $SPContext.executeQuery()
        $NewField = $Fields | where { ($_.Internalname -eq $Name) -or ($_.Title -eq $DisplayName) }
        if($NewField -ne $NULL) 
        {
            Write-host "Column $Name already exists in the List!" -f Yellow
        }
        else
        {
            # template for number fields
            #$FieldSchema = "<Field Type='Number' ID='{$FieldID}' DisplayName='$DisplayName' Name='$Name' Description='$Description' Required='$IsRequired' EnforceUniqueValues='$EnforceUniqueValues' />"
            #$NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)



            #Define XML for Field Schema
            # MaxLength='$MaxLength' for Text
            $FieldSchema = "<Field Type='$FieldType' ID='{$FieldID}' Name='$Name' StaticName='$Name' DisplayName='$DisplayName' Description='$Description' Required='$IsRequired' EnforceUniqueValues='$EnforceUniqueValues' />" 
            $NewField = $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
            $SPContext.ExecuteQuery()   
 
            Write-host "New Column Added to the List Successfully!" -ForegroundColor Green 
        }
    }
    Catch {
        write-host -f Red "Error Adding Column to List!" $_.Exception.Message
    }
}
 
<#
Function Hide-ListColumn(){
    Try {
        #Setup the context
        $SPContext= New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
        $SPContext.Credentials = $SPCredentials
   
        #Get the web, List and Field objects        
        $List=$SPContext.Web.Lists.GetByTitle($SPListName)
        $Field = $List.Fields.GetByTitle($FieldName)
 
        #Hide the column from New & Edit forms
        $Field.SetShowInEditForm($False)
        $Field.SetShowInNewForm($False)
        $Field.UpdateAndPushChanges($True)
        $SPContext.ExecuteQuery()      
        Write-host -f Green "List Field hidden Successfully!"
    }
    Catch {
        write-host -f Red "Error hiding List Column: " $_.Exception.Message
    }
}

#>
Function Insert-ListItems($SPWebURL,$SPListName, $SPCredentials, $Table){

    try {

        #$SPContext = New-Object Microsoft.SharePoint.Client.ClientContext($SPWebURL)
        #$SPContext.Credentials = $SPCredentials
 
        #Get the Web and List
        

         #Get All Lists
        #$Lists = $SPContext.Web.Lists
        #$SPContext.Load($Lists)
        #$SPContext.ExecuteQuery() 

        $SPContext, $Lists = Get-Lists $SPWebURL $SPListName $SPCredentials 
        #$Web = $SPContext.Web
        #Check if List doesn't exists already
        if($Lists.Title -contains $SPListName)
        {

            #Get the List
            $List = $SPContext.Web.Lists.GetByTitle($SPListName)
            $SPContext.Load($List)
            $SPContext.ExecuteQuery()

            $Fields = $List.Fields
            $SPContext.Load($Fields);
            $SPContext.ExecuteQuery();

            $FieldDict = @{}            
            foreach($field in $Fields){
                #$FieldDict.Add($field.Title,$field.InternalName)
                #write-host " $($field.InternalName) - $($field.Title) " -ForegroundColor Green
                $FieldDict.Add($field.InternalName,$field.Title)
                #$FieldDict.keys | Where-Object {$FieldDict["$_"] -eq $field.Title}
                # $FieldDict.Keys.Where({ $FieldDict[$PSItem] -eq $Val; }, [System.Management.Automation.WhereOperatorSelectionMode]::First);

            }

            #$SPContext.Load($Fields)
            #$SPContext.ExecuteQuery()            
            #$List.Fields | Select Title, InternalName | sort InternalName | out-file c:\listfields.txt


            $rowsCount = $Table.Rows.Count
            for ($i=0; $i -lt $Table.Rows.Count; $i++) {
                write-host "Inserting item '$($i+1)' of '$rowsCount'!" -ForegroundColor Green
                #Add new List Item
                $itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
                $listItem = $List.addItem($itemCreateInfo)
                #for ($j=0; $j -lt 4; $j++) {
                for ($j=0; $j -lt $Table.Columns.Count; $j++) {
                    #write-host "Adding field '$($j+1)' of '$($Table.Columns.Count)'!" -ForegroundColor Green
                    $FieldName = $Table.Columns[$j].ColumnName
                    $FieldValue = $Table.Rows[$i][$FieldName]
                    $tmpInternal = $FieldDict.Keys.Where({ $FieldDict[$_] -eq $FieldName; }, [System.Management.Automation.WhereOperatorSelectionMode]::First) 
                    #$tmpField = $Fields.GetByInternalNameOrTitle($FieldName); 
                    #write-host " '$FieldName' - '$tmpInternal' " -ForegroundColor Green
                    #if($FieldName -ne "ORT01"){
                        #Set Fields - Internal Name
                        $listItem.set_item($tmpInternal, $FieldValue)  
                        #$listItem[$FieldName] =  $FieldValue
                          
                    #}else{
                       #$listItem.set_item($FieldName, "abc")    
                    #}
                }
                $listItem.update();                    
                #Execute
                $SPContext.Load($listItem)
                $SPContext.ExecuteQuery() 
                #write-host "Item '$($i+1)' of '$rowsCount' has been inserted!" -ForegroundColor Green
            } 
            

        } else{
                write-host "List '$SPListName' can not be accessed!" -ForegroundColor Red
        }
    }
    Catch {
        write-host -f Red "Error Adding item to list!: " $_.Exception.Message
    }    
}


function Write-TableToList
{    
    Param
    (   [string]
        $SPWebURL,           
        [string]
        $SPListName,                   
        [parameter(Mandatory=$true)]
        $SPCredentials,                  
        [string]
        $ListMode, 
        [parameter(Mandatory=$true)]        
        $Table
    )

     try
    {

        #Delete-List $SPWebURL $SPListName $SPCredentials
        #Create-List $SPWebURL $SPListName $SPCredentials
        #Add-Fields  $SPWebURL $SPListName $SPCredentials $table.Columns 
        #Delete-AllItems $SPWebURL $SPListName $SPCredentials
        #Insert-ListItems $SPWebURL $SPListName $SPCredentials $table

        if([string]::IsNullOrEmpty($SPListName)){
            $SPListName = $Table.TableName
        }

        # $ListMode
        # Drop (default)
        # Truncate        
        # Add 
        
        if ([string]::IsNullOrEmpty($ListMode) -or $ListMode -eq "Drop"){ 
            Delete-List $SPWebURL $SPListName $SPCredentials 
            $spListGUID = Create-List $SPWebURL $SPListName $SPCredentials            
            Add-Fields -SPWebURL $SPWebURL -SPListName $SPListName -SPCredentials $SPCredentials -Columns $Table.Columns 
        }
        elseif ($ListMode -eq "Truncate"){ 
            Delete-AllItems -SPWebURL $SPWebURL -SPListName $SPListName -SPCredentials $SPCredentials
        }        
        Insert-ListItems -SPWebURL $SPWebURL -SPListName $SPListName -SPCredentials $SPCredentials -Table $Table
        
    }
    catch{
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Host $ErrorMessage $FailedItem
            Break
    }
    finally
    {
       
    }
}

########## SAP Extraction Part #################### 
function GetSAPTable
{    
    [OutputType([System.Data.DataTable])]
    #[OutputType([ERPConnectServices.ERPDataTable])]    
    Param
    (   
        [parameter(Mandatory=$true)]
        [string]
        $SPWebURL,          
        [parameter(Mandatory=$true)]
        [string]
        $YunioURL,
        [parameter(Mandatory=$true)]
        [string]
        $SapConnection,     
        $SPCredentials,
        $YunioCredentials,
        [parameter(Mandatory=$true)]
        [string]
        $TableName,
        [string[]]
        $Fields,
        [string]
        $WhereClause,
        [int]
        $RowCount=1000,
        [string]
        $CustomFunction="Z_XTRACT_IS_TABLE"
    )

     try
    {
                        
        $YunioClientSettings = New-Object ERPConnectServices.ERPConnectServiceClientSettings ($YunioURL,$SapConnection)
        $YunioClientSettings.Credentials = $YunioCredentials
        $client = New-Object ERPConnectServices.ERPConnectServiceClient($YunioClientSettings)
       
        if ($client -ne $null){

            write-host "extracting SAP Table '$TableName' ...!" -ForegroundColor Green            
            # table settings 
            $tableSettings = New-Object ERPConnectServices.ExecuteTableQuerySettings
            if($Fields -ne $null){ 
                foreach ($field in $Fields){
	                $tableSettings.Fields.Add($field)
                }
            }
            if(![string]::IsNullOrEmpty($WhereClause)){ 
                $tableSettings.WhereClause = $WhereClause 
            }

            if($RowCount -eq $null -or $RowCount -eq 0){
                $tableSettings.RowCount = 100
            } else {
                $tableSettings.RowCount = $RowCount 
            }            
            $tableSettings.CustomFunction = $CustomFunction

            # to return always as DataTable, and not as a DataRow if there is only one row          
            $table  = [System.Data.DataTable] $client.ExecuteTableQueryAsync("MAKT", $tableSettings).GetAwaiter().GetResult()                          
            #$table = $client.ExecuteTableQueryAsync("CSKT", 10).Result            

            write-host "SAP Table '$TableName' successfully extracted!" -ForegroundColor Green            
            return ,$table
            
            #return ,[System.Data.DataTable] $client.ExecuteTableQueryAsync("MAKT", $tableSettings).GetAwaiter().GetResult()  
            

        } else {
            write-host "SAP Connection for Site URL '$SPWebURL' and Sytem '$SapConnection' can't be established!" -ForegroundColor Red
        }                      
    }
    catch{
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Host $ErrorMessage $FailedItem
            Break
    }
    finally
    {
        $client.Dispose()          
    }
}


function Extract-TableToList
{    
    Param
    (   [string]
        $SPWebURL,
        [string]
        $YunioURL,                   
        [string]
        $SPListName,                   
        [parameter(Mandatory=$true)]
        $SPCredentials, 
        $YunioCredentials,                 
        [string]
        $ListMode, 
        [parameter(Mandatory=$true)]
        [string]
        $SapConnection,     
        [parameter(Mandatory=$true)]
        [string]
        $TableName,
        [string[]]
        $Fields,
        [string]
        $WhereClause,
        [int]
        $RowCount=1000,
        [string]
        $CustomFunction="Z_XTRACT_IS_TABLE"
    )
    if([string]::IsNullOrEmpty($SPListName)){ 
            $SPListName  = $TableName
    }

    $Table = GetSAPTable -YunioURL $YunioURL -YunioCredentials $YunioCredentials -SapConnection $SapConnection -SPWebURL $SPWebURL -TableName $TableName -RowCount $RowCount -Fields $Fields -WhereClause $WhereClause -CustomFunction $CustomFunction 
    Write-TableToList -SPWebURL $SPWebURL -SPCredentials $SPCredentials -Table $Table -SPListName $SPListName -ListMode $ListMode

}



function XtractSAPTable-ToList
{    
    [OutputType([System.Data.DataTable])]
    #[OutputType([ERPConnectServices.ERPDataTable])]    
    Param
    (           
        [string]
        $SPWebURL,
        [string]
        $YunioURL,                      
        [string]
        $SPListName,                   
        [string]
        $ListMode, 
        [string]
        $SapConnection,     
        [parameter(Mandatory=$true)]
        [string]
        $TableName,
        [string[]]
        $Fields,
        [string]
        $WhereClause,
        [int]
        $RowCount=0,
        [string]
        $CustomFunction="Z_XTRACT_IS_TABLE",
        $SPCredentials,
        $YunioCredentials
    )

     try
    {
        if([string]::IsNullOrEmpty($SPListName)){ 
            $SPListName  = $TableName
        }
        
        # $ListMode
        # Truncate
        # Drop (default) 
        [System.Data.DataTable] $Table = GetSAPTable -YunioURL $YunioURL -YunioCredentials $YunioCredentials -sapConnection $SapConnection -tableName $TableName -fields $Fields -whereClause $WhereClause -rowCount $RowCount -customFunction $CustomFunction -SPWebURL $SPWebURL
        
        if ([string]::IsNullOrEmpty($ListMode) -or $ListMode -eq "Drop"){ 
            Delete-List -SPWebURL $SPWebURL -SPListName $SPListName -SPCredentials $SPCredentials
            $spListGUID = Create-List -SPWebURL $SPWebURL -SPListName $SPListName -SPCredentials $SPCredentials
            Add-Fields  -SPWebURL $SPWebURL -SPListName $SPListName -Columns $Table.Columns -SPCredentials $SPCredentials
        }
        elseif ($ListMode -eq "Truncate"){ 
            Delete-AllItemsInBatch -SPWebURL $SPWebURL -SPListName $SPListName -SPCredentials $SPCredentials
        }

        Insert-ListItems -SPWebURL $SPWebURL -SPListName $SPListName -Table $Table -SPCredentials $SPCredentials
 
    }
    catch{
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Host $ErrorMessage $FailedItem
            Break
    }
    finally
    {
       
    }
}
