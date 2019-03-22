cls


$assembly = [Reflection.Assembly]::LoadFile("C:\Program Files (x86)\ERPConnect\ERPConnect45.dll")
$con = New-Object ERPConnect.R3Connection("ec5.theobald-software.com", 0, "Elzein", "Erfolg12", "EN", "800")
$con.Open($false)

$func = $con.CreateFunction("BAPI_EMPLOYEE_ENQUEUE")                
$func.Exports["NUMBER"].ParamValue = "00001300";


$func1 = $con.CreateFunction("BAPI_EMPLCOMM_CHANGE");
$func1.Exports["COMMUNICATIONID"].ParamValue = "ps@theobald.com";
$func1.Exports["EMPLOYEENUMBER"].ParamValue = "00001300";
$func1.Exports["LOCKINDICATOR"].ParamValue = "";
$func1.Exports["NOCOMMIT"].ParamValue = "";
$func1.Exports["OBJECTID"].ParamValue = "";
$func1.Exports["RECORDNUMBER"].ParamValue = "000";
$func1.Exports["SUBTYPE"].ParamValue = "0010";
$func1.Exports["VALIDITYBEGIN"].ParamValue = "20000101";
$func1.Exports["VALIDITYEND"].ParamValue = "99991231";


$func2 = $con.CreateFunction("BAPI_EMPLOYEE_DEQUEUE");
$func2.Exports["NUMBER"].ParamValue = "00001300";


Try
{
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
$con.Close()
}

$ret