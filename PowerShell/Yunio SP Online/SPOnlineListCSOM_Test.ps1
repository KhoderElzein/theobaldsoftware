#Load SharePoint CSOM Assemblies

# on a SP Server
<#
$spClientLibPath = "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
$spClientRunLibPath = "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
$ecsClientLibPath = "C:\Program Files\ERPConnect Services\ERPConnectServices.Client.dll"
$scriptPath = "C:\Users\Administrator\Documents\PowerShell\SPListCSOM.ps1"
$SPWebURL = "http://sp2016" 
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
Add-PSSnapin 'Microsoft.SharePoint.PowerShell' -ErrorAction SilentlyContinue            

Import-module $scriptPath -Force
# End Import Libraries

# SharePoint Information
$SPWebURL = "https://theobaldsoftware.sharepoint.com/sites/kesitecollection/" 
$SapConnection = "EC5" 
$YunioURL = "http://ecscoretest.eastus.cloudapp.azure.com:8080/"
$getcredential = Get-Credential -Message "Please enter your SharePoint credentials" -UserName "khoder.elzein@theobald-software.com"
$SPCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($getcredential.UserName,$getcredential.Password)  


#$getYunioCredential = Get-Credential -Message "Please enter your Yunio credentials" -UserName "nimda" # Stuttgart2010
#$YunioCredentials = New-Object System.Net.NetworkCredential($getYunioCredential.UserName,$getYunioCredential.Password)  

$YunioCredentials = New-Object System.Net.NetworkCredential("nimda","Stuttgart.2015!")  
#$ListMode = "Drop" # or "Truncate" or "Add" 

$YunioClientSettings = New-Object ERPConnectServices.ERPConnectServiceClientSettings ($YunioURL,$SapConnection)
$YunioSettings.Credentials = $YunioCredentials
$client = New-Object ERPConnectServices.ERPConnectServiceClient($YunioClientSettings)
$table = $client.ExecuteTableQueryAsync("CSKT", 10).Result

# SAP Information
$TableName = "CSKT"
$RowCount  = 10
#$SPListName = "MAKT"
#$WhereClause = "SPRAS = 'E'"
#$CustomFunction = "Z_XTRACT_IS_TABLE"
#$Fields = @("KUNNR", "ORT02")

Extract-TableToList -YunioURL $YunioURL -YunioCredentials $YunioCredentials  -SPCredentials $SPCredentials -SapConnection $SapConnection -TableName $TableName -RowCount $RowCount -SPWebURL $SPWebURL 

# In 2 Steps
# 1. Step: Extract SAP Table
# 2. Step: Write SAP Table to an SP List 
$Table = GetSAPTable -SPWebURL $SPWebURL -YunioURL $YunioURL -YunioCredentials $YunioCredentials -SapConnection $SapConnection -TableName $TableName -RowCount 50 #-Fields @("KUNNR", "ORT02")
Write-TableToList -WebURL $SPWebURL -Credentials $SPCredentials -Table $Table

# SP Operations 
Delete-List $SPWebURL $ListName $SPCredentials
Create-List $SPWebURL $ListName $SPCredentials
Add-Fields  $SPWebURL $ListName $SPCredentials $Table.Columns 
Delete-AllItems $SPWebURL $Listname $SPCredentials
Insert-ListItems $SPWebURL $ListName $SPCredentials $Table