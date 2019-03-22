Import-module C:\Users\Elzein\Documents\PowerShell\CreateSPListOnline.ps1 -Force
#Import-module C:\Users\Elzein\Documents\PowerShell\ExtractSAPTable.ps1 -Force

#[appdomain]::CurrentDomain.GetAssemblies()


#Variables for Processing
$WebURL = "https://theobaldsoftware.sharepoint.com/sites/kesitecollection/"
$ListName="KELIST0326A"
 
#Setup Credentials to connect
#$cred = Get-Credential
#$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($cred.UserName,$cred.Password)

$UserName="khoder.elzein@theobald-software.com"
$Password ="Theobald9"
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force)) 

cls
Delete-List $WebURL $ListName $Credentials
Create-List $WebURL $ListName $Credentials
Add-Fields  $WebURL $ListName $Credentials $table.Columns 

$sapConnection = "EC5"
[System.Data.DataTable] $table = GetSAPTable -sapConnection $sapConnection -tableName "MAKT" -rowCount 15 -WhereClause "SPRAS = 'E'"
