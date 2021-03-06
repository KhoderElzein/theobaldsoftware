$erpconnectpath = "C:\Users\Elzein\Documents\PowerShell\Generate XU Extractions\ERPConnect35.dll"
$erpconnectLicense = "ZYYZVZY77Z"
clear
try
{
   $erpConnectType = Add-Type -Path $erpconnectpath
}
catch [System.Reflection.ReflectionTypeLoadException]
{
   Write-Host "Message: $($_.Exception.Message)"
   Write-Host "StackTrace: $($_.Exception.StackTrace)"
   Write-Host "LoaderExceptions: $($_.Exception.LoaderExceptions)"
}

function Restart-Shell
{
    Start-Process PowerShell.exe
    exit
}
New-Alias "rss" "Restart-Shell"
rss

# initialize license
# 1.1.20
[ERPConnect.LIC]::SetLic($erpconnectLicense)

# initialize connection

Function Get-Connection($SAPHost, $Client, $SystemNumber, $User, $Password, $Language){

    Try {
		$con = New-Object ERPConnect.R3Connection
		$con.UserName = $User
		$con.Password = $Password
		$con.Language = $Language
		$con.Client = $Client 
		$con.Host = $SAPHost
		$con.SystemNumber = $SystemNumber
		#$con.Protocol = ClientProtocol.NWRFC;   # Optional: If the NW RFC libraries are used.
		$con.Open($false);         
        return $con
        }         
    Catch {
        write-host -f Red "Error Getting Connection: " $_.Exception.Message
    }

}


Function Get-Table($Connection,$TableName, $TableFields, $WhereClause, $RowCount){

    Try {
		$table = New-Object  ERPConnect.Utils.ReadTable($con); 
		$table.WhereClause = $WhereClause
		$table.TableName = $TableName
		
		foreach($field in $TableFields){
                $table.AddField($field)                
            }

		If ($RowCount -ne $null -and $RowCount -gt 0){ 
				$table.RowCount = $RowCount
		}
		$table.Run();        
		$ResultTable = $table.Result;  
		return $ResultTable
        }         
    Catch {
        write-host -f Red "Error Getting Table: $TableName, $TableFields, $WhereClause, $RowCount" $_.Exception.Message
    }
}

# ($SAPHost, $Client, $SystemNumber, $User, $Password, $Language)
$Con = Get-Connection("ec5.theobald-software.com","800",0,"Elzein","Erfolg12","EN") 
$resulttable = Get-Table($Con,"MAKT", {"MATNR", "MAKTX"}, "SPRAS = 'EN' AND MATNR LIKE '%23'", 10)
$Con.Close(); 


