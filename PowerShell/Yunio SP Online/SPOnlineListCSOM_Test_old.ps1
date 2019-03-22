#Load SharePoint CSOM Assemblies

# on a SP Server
<#
$spClientLibPath = "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
$spClientRunLibPath = "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
$ecsClientLibPath = "C:\Program Files\ERPConnect Services\ERPConnectServices.Client.dll"
$scriptPath = "C:\Users\Administrator\Documents\PowerShell\SPListCSOM.ps1"
$WebURL = "http://sp2016" 
#>

# KE Laptop
$spClientLibPath = "C:\Users\Elzein\Documents\CSOM\Microsoft.SharePoint.Client.dll"
$spClientRunLibPath = "C:\Users\Elzein\Documents\CSOM\Microsoft.SharePoint.Client.Runtime.dll"
#$ecsClientLibPath = "C:\Program Files\ERPConnectServices2016\ERPConnectServices.Client.dll"
$yunioClientLibPath = "C:\Program Files\ERPConnect Services Core\Clients\NET45\ERPConnectServices.ClientCore.dll"
$scriptPath = "C:\Users\Elzein\Documents\PowerShell\Yunio SP Online\SPOnlineListCSOM.ps1"

<#
function Restart-Shell
{
    Start-Process PowerShell.exe
    exit
}
New-Alias "rss" "Restart-Shell"
rss
#>

# Begin Import Libraries
$csomC = Add-Type -Path $spClientLibPath
$csomCR = Add-Type -Path $spClientRunLibPath
#$ecsClient = Add-Type -Path $ecsClientLibPath
$yunioClient = Add-Type -Path $yunioClientLibPath 
Import-module $scriptPath -Force
Add-PSSnapin 'Microsoft.SharePoint.PowerShell' -ErrorAction SilentlyContinue            
# End Import Libraries

# SharePoint Information
$WebURL = "https://theobaldsoftware.sharepoint.com/sites/kesitecollection/" 
$SapConnection = "EC5" 
$YunioURL = "http://ecscoretest.eastus.cloudapp.azure.com:8080/"
$getcredential = Get-Credential -Message "Please enter your SharePoint credentials" -UserName "khoder.elzein@theobald-software.com"
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($getcredential.UserName,$getcredential.Password)  


#$getYunioCredential = Get-Credential -Message "Please enter your Yunio credentials" -UserName "nimda" # Stuttgart2010
#$YunioCredentials = New-Object System.Net.NetworkCredential($getYunioCredential.UserName,$getYunioCredential.Password)  

$YunioNetworkCredentials = New-Object System.Net.NetworkCredential("nimda","Stuttgart.2015!")  
#$ListMode = "Drop" # or "Truncate" or "Add" 

$YunioClientSettings = New-Object ERPConnectServices.ERPConnectServiceClientSettings ($YunioURL,$SapConnection)
$YunioSettings.Credentials = $YunioNetworkCredentials
$client = New-Object ERPConnectServices.ERPConnectServiceClient($YunioClientSettings)
$table = $client.ExecuteTableQueryAsync("CSKT", 10).Result

# SAP Information
$TableName = "MAKT"
$ListName = "MAKT"
$RowCount  = 10
#$WhereClause = "SPRAS = 'E'"
#$CustomFunction = "Z_XTRACT_IS_TABLE"
#$Fields = @("KUNNR", "ORT02")

Extract-TableToList -YunioURL $YunioURL -YunioNetworkCredentials $YunioNetworkCredentials  -Credentials $Credentials -SapConnection $SapConnection -TableName $TableName -ListName $TableName -RowCount $RowCount -WebURL $WebURL 

# In 2 Steps
# 1. Step: Extract SAP Table
# 2. Step: Write SAP Table to an SP List 
$Table = GetSAPTable -WebURL $WebURL -YunioURL $YunioURL -YunioNetworkCredentials $YunioNetworkCredentials -SapConnection $SapConnection -TableName $TableName -RowCount 50 #-Fields @("KUNNR", "ORT02")
Write-TableToList -WebURL $WebURL -Credentials $Credentials -Table $Table

# SP Operations 
Delete-List $WebURL $ListName $Credentials
Create-List $WebURL $ListName $Credentials
Add-Fields  $WebURL $ListName $Credentials $Table.Columns 
Delete-AllItems $WebURL $Listname $Credentials
Insert-ListItems $WebURL $ListName $Credentials $Table

