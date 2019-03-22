cls
# load assembly 
$assembly = [Reflection.Assembly]::LoadFile("C:\Program Files\ERPConnectServices2016\ERPConnectServices.Client.dll")
#$assembly.FullName

$url = "http://54.91.96.42"
$sapcon = "EC5"
$domain = "sp2016"
$user = "Administrator"
$password = "Sharepoint.2016"

# authentication object 
$auth = New-Object ERPConnectServices.ERPConnectServiceAuthenticationProvider($domain,$user,$password,"mycookie")
# connection / client 
$con = New-Object ERPConnectServices.ERPConnectServiceClient($url,$sapcon,$auth)

# enqueue
$func = $con.CreateFunction("BAPI_EMPLOYEE_ENQUEUE")                
$func.Exports["NUMBER"].ParamValue = "00001300";

# change email
$func1 = $con.CreateFunction("BAPI_EMPLCOMM_CHANGE");
$func1.Exports["COMMUNICATIONID"].ParamValue = "ps5@theobald.com";
$func1.Exports["EMPLOYEENUMBER"].ParamValue = "00001300";
$func1.Exports["LOCKINDICATOR"].ParamValue = "";
$func1.Exports["NOCOMMIT"].ParamValue = "";
$func1.Exports["OBJECTID"].ParamValue = "";
$func1.Exports["RECORDNUMBER"].ParamValue = "000";
$func1.Exports["SUBTYPE"].ParamValue = "0010";
$func1.Exports["VALIDITYBEGIN"].ParamValue = "20000101";
$func1.Exports["VALIDITYEND"].ParamValue = "99991231";

# dequeue
$func2 = $con.CreateFunction("BAPI_EMPLOYEE_DEQUEUE");
$func2.Exports["NUMBER"].ParamValue = "00001300";


Try
{
	# execute the 3 functions in sequence and on scope
    $con.BeginConnectionScope()
	$func.Execute()
    $func1.Execute()
    $func2.Execute()
	

    $ret = $func1.Imports[0].ToStructure               
    $type = $ret["TYPE"]
    $message = $ret["MESSAGE"]	

}
Catch [ERPConnect.Exception]
{

}
Catch
{
    $ErrorMessage = $_.Exception.Message    
    echo $ErrorMessage
    Break
}
Finally
{
$con.EndConnectionScope()
}

echo $type " " $message