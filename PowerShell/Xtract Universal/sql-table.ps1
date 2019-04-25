# set the path to the installation folder
$XUCmd = 'C:\Program Files\XtractUniversal\xu.exe'
# XU server & port 
$XUServer = "localhost"
$XUPort = "8065"

# run an extraction 
&$XUCmd -s $XUServer -p $XUPort -n $XUExtraction 1>$null 2>&1 

$SQLServer = "localhost"
$SQLDatabase = "xuSAPData"
#$SQLStatement = "SELECT TOP 5 [MATNR],[WERKS]  FROM [xuSAPData].[dbo].[tw_materialjoin] where WERKS <> ''"
#$SQLStatement = "SELECT TOP 5 [MATNR],[WERKS]  FROM [xuSAPData].[dbo].[tw_materialjoin] where MATNR = '100-100'"
$SQLStatement = "SELECT TOP 10 [MATNR],[WERKS]  FROM [xuSAPData].[dbo].[tw_materialjoin] where WERKS = '1000'"

$sqlTable = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $SQLStatement


# http://chaplin.theobald.local:8065/?name=tw_mat_stock_param&material=&plant=
$sqlTable | ForEach-Object {
	# initiate the variables 
	$Material= $_.MATNR
	$Plant= $_.WERKS
	# execute the SAP function module 
	&$XUCmd -s $XUServer -p $XUPort -n tw_mat_stock_param -o  material=$Material -o plant=$Plant
}
