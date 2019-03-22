#Load SharePoint CSOM Assemblies
$csomc = Add-Type -Path "C:\Users\Elzein\Documents\CSOM\Microsoft.SharePoint.Client.dll"
$csomcr = Add-Type -Path "C:\Users\Elzein\Documents\CSOM\Microsoft.SharePoint.Client.Runtime.dll"
  
Function Create-List($WebURL, $ListName, $Credentials)
{ 
    Try {
        #Setup the context
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)        
        $Context.Credentials = $Credentials
     
        #Get All Lists
        $Lists = $Context.Web.Lists
        $Context.Load($Lists)
        $Context.ExecuteQuery() 
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
  
            write-host  -f Green "New List has been created!"
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
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Context.Credentials = $Credentials
     
        #Get All Lists
        $Lists = $Context.Web.Lists
        $Context.Load($Lists)
        $Context.ExecuteQuery() 
        #Check if List doesn't exists already
        if($Lists.Title -contains $ListName)
        {
            #Get the List
            $List=$Context.Web.Lists.GetByTitle($ListName)            
            $List.DeleteObject()
            $Context.ExecuteQuery()         
            Write-host -f Green "List Deleted Successfully!"
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


##Variables for Processing

$FieldToAdd="ID"
#$UserName="Salaudeen@crescent.com"
#$Password ="Password goes here"
#$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force)) 

Function Add-ViewField ($WebURL, $ListName, $Credentials){
    Try {
     
        #$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
 
        #Get Web information and subsites
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $Credentials
     
        #get the list
        $List = $Context.web.lists.GetByTitle($Listname)
     
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

Function Remove-ViewField ($WebURL, $ListName, $Credentials){
    Try {   
        #$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
 
        #Setup the context
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $credentials
     
        #get the list
        $List = $Context.web.lists.GetByTitle($Listname)
     
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

Function Delete-AllItems($WebURL,$Listname,$Credentials){
    try {
        #Set up the context
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebUrl)
        $Context.Credentials = $Credentials
   
        #Get the List
        $List = $Context.web.Lists.GetByTitle($ListName)
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
    }
    catch {
        write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
    }
    
}
Function Update-ItemById ($WebURL,$Listname,$Credentials, $ID,$Title){

    try{
    
        #Setup the context
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $Credentials
     
        #get the list
        $List = $Context.web.lists.GetByTitle($Listname)
   
        #Filter and Get the List Items using CAML
        $List = $Context.web.Lists.GetByTitle($ListName)
 
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


function Add-Fields($WebURL, $ListName,$Credentials, $Columns) {

        #Setup the context
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Context.Credentials = $Credentials
     
        #Get All Lists
        $Lists = $Context.Web.Lists
        $Context.Load($Lists)
        $Context.ExecuteQuery() 
        #Check if List doesn't exists already
        if($Lists.Title -contains $ListName)
        {
    
        # title field
        #$titleField = $spList.Fields["Title"] 
        #$titleField.SetCustomProperty("Required",$false) 
        #$titleField.SetCustomProperty("Hidden",$true) 
        #$spList.Update()

        #view
        #$view = $spList.DefaultView
        #$viewFields = $view.ViewFields
        # delete title field from view
        #if ($viewFields.Exists("LinkTitle")){
        #    $viewFields.Delete("LinkTitle")
        #}
        #$view.Update()

        #Get the List
        $List = $Context.Web.Lists.GetByTitle($ListName)
        $Context.Load($List)
        $Context.ExecuteQuery()

        #$listFields = $spList.Fields
        $Fields = $List.Fields
        $Context.Load($Fields)
        $Context.executeQuery()
    
        for ($i=0; $i -lt $Columns.Count; $i++) {         
            $FieldType = "Text"
            $FieldName = $Table.Columns[$i].ColumnName                
            #Add-ListField -WebURL $WebURL -ListName $ListName -Credentials $Credentials -FieldType $FieldType -Name $FieldName -DisplayName $FieldName -Description $FieldName -IsRequired $false -EnforceUniqueValues $false                          

                #Generate new GUID for Field ID
            $FieldID = [guid]::NewGuid()      
            #Check if the column exists in list already
            $NewField = $Fields | where { ($_.Internalname -eq $FieldName) -or ($_.Title -eq $FieldName) }
            if($NewField -ne $NULL) 
            {
                Write-host "Column $FieldName already exists in the List!" -f Yellow
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

                Write-host "New Column Added to the List Successfully!" -ForegroundColor Green 
            }
    
        }        
        
        
        

        #add fields to view 
        #for ($i=0; $i -lt $Columns.Count; $i++) {
        #    Write-Host $i
        #    $field = [FieldClass] $Columns[$i]
        #    if($field -ne $null){                         
        #        if(!$viewFields.Exists($FieldName)){
        #            $viewFields.Add($FieldName)
        #            
        #        }                
        #    }
        #}	    

        #$spWeb.Dispose()           
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
        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $Credentials
         
        #Get the List
        $List = $Context.Web.Lists.GetByTitle($ListName)
        $Context.Load($List)
        $Context.ExecuteQuery()
 
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
 
Function Hide-ListColumn(){
    Try {
        #Setup the context
        $Context= New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $Credentials
   
        #Get the web, List and Field objects
        $Web=$Context.Web
        $List=$Web.Lists.GetByTitle($ListName)
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

Function Insert-ListItem($WebURL,$ListName, $Credentials, $FieldName, $FieldValue){

    try {

        $Context = New-Object Microsoft.SharePoint.Client.ClientContext($WebURL)
        $Context.Credentials = $Credentials
 
        #Get the Web and List
        $Web = $Context.Web
        $List = $Web.Lists.GetByTitle($ListName)
  
        #Add new List Item
        $itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
        $listItem = $list.addItem($itemCreateInfo)
 
        #Set Fields - Internal Name
        $listItem.set_item($FieldName, $FieldValue)    
        $listItem.update();
 
        #Execute
        $Context.Load($listItem)
        $Context.ExecuteQuery() 
 
        write-host "New Item has been Added!" -ForegroundColor Green            
    }
    Catch {
        write-host -f Red "Error Adding item to list!: " $_.Exception.Message
    }    
}

