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
$ecsClientLibPath = "C:\Program Files\ERPConnectServices2016\ERPConnectServices.Client.dll"
$scriptPath = "C:\Users\Elzein\Documents\PowerShell\SPListCSOM.ps1"


# Begin Import Libraries
$csomc = Add-Type -Path $spClientLibPath
$csomcr = Add-Type -Path $spClientRunLibPath
$ecsclient = Add-Type -Path $ecsClientLibPath
Import-module $scriptPath -Force
Add-PSSnapin 'Microsoft.SharePoint.PowerShell' -ErrorAction SilentlyContinue            
# End Import Libraries

# SharePoint Information
$WebURL = "http://54.147.34.243" 
$SapConnection = "EC5" 
$getcredential = Get-Credential -Message "Please enter your SharePoint credentials" -UserName "Administrator"
$Credentials = New-Object System.Net.NetworkCredential($getcredential.UserName,$getcredential.Password, "sp2016")  
#$ListMode = "Drop" # or "Truncate" or "Add" 

# SAP Information
$TableName = "CSKT"
$RowCount  = 10
#$WhereClause = "SPRAS = 'E'"
#$CustomFunction = "Z_XTRACT_IS_TABLE"
#$Fields = @("KUNNR", "ORT02")

Extract-TableToList -Credentials $Credentials -SapConnection $SapConnection -TableName $TableName -RowCount $RowCount -WebURL $WebURL

# In 2 Steps
# 1. Step: Extract SAP Table
# 2. Step: Write SAP Table to an SP List 
#$Table = GetSAPTable -SapConnection $SapConnection -TableName $TableName -RowCount 50 #-Fields @("KUNNR", "ORT02")
#Write-TableToList -Credentials $Credentials -Table $Table

# SP Operations 
#Delete-List $WebURL $ListName $Credentials
#Create-List $WebURL $ListName $Credentials
#Add-Fields  $WebURL $ListName $Credentials $Table.Columns 
#Delete-AllItems $WebURL $Listname $Credentials
#Insert-ListItems $WebURL $ListName $Credentials $Table

