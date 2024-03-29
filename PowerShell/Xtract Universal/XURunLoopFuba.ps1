$Mandt="200"
$ProductNr="10" 
$Desc= "Test Powershell Line"
$ProductType= "TXT"
$Quantity="10"
$Unit="PC" 
$CreationDate= (Get-Date -format "yyyyMMdd")
$CreationTime= (Get-Date -format "HHmmss")

&$XUCmd -s "chaplin.theobald.local" -p "8065" -n createzproducts -o  Mandt=$Mandt -o ProductNr=$ProductNr -o Desc=$Desc -o ProductType=$ProductType -o Quantity=$Quantity -o Unit=$Unit -o CreationDate=$CreationDate -o CreationTime=$CreationTime


# read csv file without header 
$csvFile = Import-Csv "C:\Users\Elzein\Documents\PowerShell\Xtract Universal\SAPProducts.txt"
# loop the lines
$csvFile | ForEach-Object {
	# initiate the variables 
	$Mandt= $_.Mandt
	$ProductNr= $_.ProductNr
	$Desc= $_.Desc
	$ProductType= $_.ProductType
	$Quantity= $_.Quantity
	$Unit= $_.Unit
	$CreationDate= (Get-Date -format "yyyyMMdd")
	$CreationTime= (Get-Date -format "HHmmss")
	# execute the SAP function module 
	&$XUCmd -s "chaplin.theobald.local" -p "8065" -n createzproducts -o  Mandt=$Mandt -o ProductNr=$ProductNr -o Desc=$Desc -o ProductType=$ProductType -o Quantity=$Quantity -o Unit=$Unit -o CreationDate=$CreationDate -o CreationTime=$CreationTime
}

