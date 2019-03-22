 
Function Get-Lists($WebURL, $ListName, $Credentials){

    Try {
        #Setup the context
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)        
        $Context.Credentials = $Credentials
     
        #Get All Lists
        $Lists = $Context.Web.Lists
        $Context.Load($Lists)
        $Context.ExecuteQuery() 
        #Check if List doesn't exists already
        
        return $Context, $Lists
        }         
    Catch {
        write-host -f Red "Error Getting List '$ListName'!" $_.Exception.Message
    }

}

Function Create-List($WebURL, $ListName, $Credentials)
{ 
    Try {
        #Setup the context
        #$Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)        
        #$Context.Credentials = $Credentials
     
        #Get All Lists
        #$Lists = $Context.Web.Lists
        #$Context.Load($Lists)
        #$Context.ExecuteQuery() 
        $Context, $Lists = Get-Lists $WebURL $ListName $Credentials

        #Check if List doesn't exists already
        if(!($Lists.Title -contains $ListName))
        {
            #sharepoint online powershell create list
            $ListInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
            $ListInfo.Title = $ListName
            $ListInfo.TemplateType = 100 #Custom List
            $List = $Context.Web.Lists.Add($ListInfo)
            #$List.Description = "Repository to store project artifacts"
            $List.Update()
            $Context.ExecuteQuery()
  
            write-host  -f Green "List '$ListName' has been created!"
        }
        else
        {
            Write-Host -f Red "List '$ListName' already exists!"
        }
    }
    Catch {
        write-host -f Red "Error Creating List!" $_.Exception.Message
    }


}

Function Delete-List($WebURL, $ListName, $Credentials)
{ 
    Try {
        #Setup the context
        #$Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        #$Context.Credentials = $Credentials
     
        #Get All Lists
        #$Lists = $Context.Web.Lists
        #$Context.Load($Lists)
        #$Context.ExecuteQuery() 

        $Context, $Lists = Get-Lists $WebURL $ListName $Credentials
        #Check if List doesn't exists already
        if($Lists.Title -contains $ListName)
        {
            #Get the List
            $List=$Context.Web.Lists.GetByTitle($ListName)            
            $List.DeleteObject()
            $Context.ExecuteQuery()         
            Write-host -f Green "List '$ListName' Deleted Successfully!"
        }
        else
        {
            Write-Host -f Red "List '$ListName' does not exist!"
        }
    }
    Catch {
        write-host -f Red "Error Creating List!" $_.Exception.Message
    }


}

<#
Function Add-ViewField ($WebURL, $ListName, $Credentials){
    Try {
     
        #$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
 
        #Get Web information and subsites
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $Credentials
     
        #get the list
        $List = $Context.Web.Lists.GetByTitle($Listname)
     
        #Check if View has the field already
        $ViewFields = $List.DefaultView.ViewFields
        # Get a specific list view by Name
        #$view=$List.Views.getByTitle($ViewName)
        $Context.load($ViewFields) 
        $Context.ExecuteQuery() 
 
        if( ($ViewFields -Contains $FieldToAdd) -eq $false) {
            #Add the Field to View
            $List.DefaultView.ViewFields.Add($FieldToAdd)
            $List.DefaultView.Update()
            $Context.ExecuteQuery()
 
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
Function Remove-ViewField ($WebURL, $ListName, $Credentials){
    Try {   
        #$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
 
        #Setup the context
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $credentials
     
        #get the list
        $List = $Context.Web.Lists.GetByTitle($Listname)
     
        #Check if the View has the field in it
        $ViewFields = $List.DefaultView.ViewFields
        $Context.load($ViewFields) 
        $Context.ExecuteQuery() 
 
        if( ($ViewFields -Contains $FieldToAdd) -eq $true) {
            #Add the Field to View
            $List.DefaultView.ViewFields.Remove($FieldToAdd)
            $List.DefaultView.Update()
            $Context.ExecuteQuery()
 
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
Function Delete-AllItems($WebURL,$Listname,$Credentials){
    try {
        #Set up the context
        #$Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebUrl)
        #$Context.Credentials = $Credentials

        $Context, $Lists = Get-Lists $WebURL $ListName $Credentials

        if($Lists.Title -contains $ListName)
        {
             #Get the List
            $List = $Context.Web.Lists.GetByTitle($ListName)
            $ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
            $Context.Load($ListItems)
            $Context.ExecuteQuery()      
 
            write-host "Total Number of List Items found:"$ListItems.Count
 
            if ($ListItems.Count -gt 0)
            {
                #Loop through each item and delete
                For ($i = $ListItems.Count-1; $i -ge 0; $i--)
                {
                    $ListItems[$i].DeleteObject()
                }
                $Context.ExecuteQuery()
         
                Write-Host "All List Items deleted Successfully!" -foregroundcolor Green
            }           
  
            #write-host  -f Green "List '$ListName' has been created!"
        }
        else
        {
            Write-Host -f Red "List '$ListName' not found!"
        }   
    }
    catch {
        write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
    }
    
}

<#
Function Update-ItemById ($WebURL,$Listname,$Credentials, $ID,$Title){

    try{
    
        #Setup the context
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $Credentials
     
        #get the list
        $List = $Context.Web.Lists.GetByTitle($Listname)
   
        #Filter and Get the List Items using CAML
        #$List = $Context.web.Lists.GetByTitle($ListName)
 
        #Get List Item by ID
        $ListItem = $List.GetItemById($ID) 
 
        #Update List Item title
        $ListItem["Title"] = $Title
        $ListItem.Update() 
 
        $Context.ExecuteQuery()
        write-host "Item Updated!"  -foregroundcolor Green 
    }
    catch{ 
        write-host "$($_.Exception.Message)" -foregroundcolor red 
    } 


#Read more: http://www.sharepointdiary.com/2015/07/sharepoint-online-update-list-items-using-powershell.html#ixzz5AqzMpAN5
}
#>

function Add-Fields($WebURL, $ListName,$Credentials, $Columns) {

    
    #Setup the context
    #$Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
    #$Context.Credentials = $Credentials
     
    #Get All Lists
    #$Lists = $Context.Web.Lists
    #$Context.Load($Lists)
    #$Context.ExecuteQuery() 

    $Context, $Lists = Get-Lists $WebURL $ListName $Credentials 

    #Check if List doesn't exists already
    if($Lists.Title -contains $ListName)
    {   

        #Get the List
        $List = $Context.Web.Lists.GetByTitle($ListName)
        $Context.Load($List)
        $Context.ExecuteQuery()

        $Fields = $List.Fields        
        $DefaultView = $List.DefaultView
        $ViewFields = $DefaultView.ViewFields
        $Context.Load($Fields)
        $Context.Load($DefaultView)
        $Context.Load($ViewFields)
        $Context.executeQuery()

        $TitleField = $Fields | where { ($_.Internalname -eq "Title" -or $_.Title -eq "Title") }
        if($TitleField -ne $NULL) 
        {
            $TitleField = $List.Fields.GetByInternalNameOrTitle("Title")
            $TitleField.Required = $false;                
        }
       
        $ViewField = $ViewFields | where { ($_.Internalname -eq "LinkTitle") -or ($_.Title -eq "LinkTitle") }
        if($ViewField -ne $NULL) 
        {
            $DefaultView.ViewFields.Remove("LinkTitle")              
        }
        $DefaultView.Update()
        $Context.ExecuteQuery()        
  
        if($Columns.Count -eq 0){
            write-host "Input parameter does not contain any fields" -foregroundcolor red 
        } else { 
        for ($i=0; $i -lt $Columns.Count; $i++) {         
            $FieldName = $Table.Columns[$i].ColumnName
            if(![string]::IsNullOrEmpty($FieldName)){
                $FieldType = "Text"                            
                #Add-ListField -WebURL $WebURL -ListName $ListName -Credentials $Credentials -FieldType $FieldType -Name $FieldName -DisplayName $FieldName -Description $FieldName -IsRequired $false -EnforceUniqueValues $false                          
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
                    $Context.ExecuteQuery()   

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
        [Parameter(Mandatory=$true)] [string] $WebURL,
        [Parameter(Mandatory=$true)] [string] $ListName,
        $Credentials,
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
        #$Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        #$Context.Credentials = $Credentials
         
        #Get the List
        #$List = $Context.Web.Lists.GetByTitle($ListName)
        #$Context.Load($List)
        #$Context.ExecuteQuery()
 
        $Context, $Lists = Get-Lists $WebURL $ListName $Credentials
        #Check if the column exists in list already
        $Fields = $List.Fields
        $Context.Load($Fields)
        $Context.executeQuery()
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
            $Context.ExecuteQuery()   
 
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
        $Context= New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $Credentials
   
        #Get the web, List and Field objects        
        $List=$Context.Web.Lists.GetByTitle($ListName)
        $Field = $List.Fields.GetByTitle($FieldName)
 
        #Hide the column from New & Edit forms
        $Field.SetShowInEditForm($False)
        $Field.SetShowInNewForm($False)
        $Field.UpdateAndPushChanges($True)
        $Context.ExecuteQuery()      
        Write-host -f Green "List Field hidden Successfully!"
    }
    Catch {
        write-host -f Red "Error hiding List Column: " $_.Exception.Message
    }
}

#>
Function Insert-ListItems($WebURL,$ListName, $Credentials, $Table){

    try {

        #$Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        #$Context.Credentials = $Credentials
 
        #Get the Web and List
        

         #Get All Lists
        #$Lists = $Context.Web.Lists
        #$Context.Load($Lists)
        #$Context.ExecuteQuery() 

        $Context, $Lists = Get-Lists $WebURL $ListName $Credentials 
        #$Web = $Context.Web
        #Check if List doesn't exists already
        if($Lists.Title -contains $ListName)
        {

            #Get the List
            $List = $Context.Web.Lists.GetByTitle($ListName)
            $Context.Load($List)
            $Context.ExecuteQuery()

            $Fields = $List.Fields
            $Context.Load($Fields);
            $Context.ExecuteQuery();

            $FieldDict = @{}            
            foreach($field in $Fields){
                #$FieldDict.Add($field.Title,$field.InternalName)
                #write-host " $($field.InternalName) - $($field.Title) " -ForegroundColor Green
                $FieldDict.Add($field.InternalName,$field.Title)
                #$FieldDict.keys | Where-Object {$FieldDict["$_"] -eq $field.Title}
                # $FieldDict.Keys.Where({ $FieldDict[$PSItem] -eq $Val; }, [System.Management.Automation.WhereOperatorSelectionMode]::First);

            }

            #$Context.Load($Fields)
            #$Context.ExecuteQuery()            
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
                $Context.Load($listItem)
                $Context.ExecuteQuery() 
                #write-host "Item '$($i+1)' of '$rowsCount' has been inserted!" -ForegroundColor Green
            } 
            

        } else{
                write-host "List '$ListName' can not be accessed!" -ForegroundColor Red
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
        $WebURL,           
        [string]
        $ListName,                   
        [parameter(Mandatory=$true)]
        $Credentials,                  
        [string]
        $ListMode, 
        [parameter(Mandatory=$true)]        
        $Table
    )

     try
    {

        #Delete-List $WebURL $ListName $Credentials
        #Create-List $WebURL $ListName $Credentials
        #Add-Fields  $WebURL $ListName $Credentials $table.Columns 
        #Delete-AllItems $WebURL $Listname $Credentials
        #Insert-ListItems $WebURL $ListName $Credentials $table

        if([string]::IsNullOrEmpty($ListName)){
            $ListName = $Table.TableName
        }

        # $ListMode
        # Drop (default)
        # Truncate        
        # Add 
        
        if ([string]::IsNullOrEmpty($ListMode) -or $ListMode -eq "Drop"){ 
            Delete-List $WebURL $ListName $Credentials 
            $spListGUID = Create-List $WebURL $ListName $Credentials            
            Add-Fields -WebURL $WebURL -ListName $ListName -Credentials $Credentials -Columns $Table.Columns 
        }
        elseif ($ListMode -eq "Truncate"){ 
            Delete-AllItems -WebURL $WebURL -ListName $ListName -Credentials $Credentials
        }        
        Insert-ListItems -WebURL $WebURL -ListName $ListName -Credentials $Credentials -Table $Table
        
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
        $WebURL,          
        [parameter(Mandatory=$true)]
        [string]
        $YunioURL,
        [parameter(Mandatory=$true)]
        [string]
        $SapConnection,     
        $Credentials,
        $YunioNetworkCredentials,
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
        $YunioClientSettings.Credentials = $YunioNetworkCredentials
        $client = New-Object ERPConnectServices.ERPConnectServiceClient($YunioClientSettings)
       
        if ($client -ne $null){

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
            #$table  = [System.Data.DataTable] $client.ExecuteTableQueryAsync("MAKT", $tableSettings).GetAwaiter().GetResult()              
            #$table = $client.ExecuteTableQueryAsync("CSKT", 10).Result            
            #return $table
            return ,[System.Data.DataTable] $client.ExecuteTableQueryAsync("MAKT", $tableSettings).GetAwaiter().GetResult()              

        } else {
            write-host "SAP Connection for Site URL '$WebURL' and Sytem '$SapConnection' can't be established!" -ForegroundColor Red
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
        $WebURL,
        [string]
        $YunioURL,                   
        [string]
        $ListName,                   
        [parameter(Mandatory=$true)]
        $Credentials, 
        $YunioNetworkCredentials,                 
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
    $Table = GetSAPTable -YunioURL $YunioURL -YunioNetworkCredentials $YunioNetworkCredentials -SapConnection $SapConnection -WebURL $WebURL -TableName $TableName -RowCount $RowCount -Fields $Fields -WhereClause $WhereClause -CustomFunction $CustomFunction 
    Write-TableToList -WebURL $WebURL -Credentials $Credentials -Table $Table -ListName $ListName -ListMode $ListMode

}



function XtractSAPTable-ToList
{    
    [OutputType([System.Data.DataTable])]
    #[OutputType([ERPConnectServices.ERPDataTable])]    
    Param
    (           
        [string]
        $WebURL,
        [string]
        $YunioURL,                      
        [string]
        $ListName,                   
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
        $Credentials,
        $YunioNetworkCredentials
    )

     try
    {
        if([string]::IsNullOrEmpty($ListName)){ 
            $ListName  = $TableName
        }
        
        # $ListMode
        # Truncate
        # Drop (default) 
        [System.Data.DataTable] $Table = GetSAPTable -YunioURL $YunioURL -YunioNetworkCredentials $YunioNetworkCredentials -sapConnection $SapConnection -tableName $TableName -fields $Fields -whereClause $WhereClause -rowCount $RowCount -customFunction $CustomFunction -WebURL $WebURL
        
        if ([string]::IsNullOrEmpty($ListMode) -or $ListMode -eq "Drop"){ 
            Delete-List -WebURL $WebURL -ListName $ListName -Credentials $Credentials
            $spListGUID = Create-List -WebURL $WebURL -ListName $ListName -Credentials $Credentials
            Add-Fields  -WebURL $WebURL -ListName $ListName -Columns $Table.Columns -Credentials $Credentials
        }
        elseif ($ListMode -eq "Truncate"){ 
            Delete-AllItemsInBatch -WebURL $WebURL -ListName $ListName -Credentials $Credentials
        }

        Insert-ListItems -siteurl $WebURL -ListName $ListName -Table $Table -Credentials $Credentials
 
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
