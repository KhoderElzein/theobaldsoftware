<#
Requirements
- XU Server is running
- Extractions GetFieldDescription and GetTableDescription with http-csv Destination are available

#>

$scriptPath = "C:\Users\Elzein\Documents\PowerShell\Generate XU Extractions\generatexuextraction.ps1"
$outputPath = "C:\Users\Elzein\Documents\PowerShell\Generate XU Extractions\output\"
$joinTableTemplatePath = "C:\Users\Elzein\Documents\PowerShell\Generate XU Extractions\templates\jointable\"

# Begin Import Libraries
Import-module $scriptPath -Force
# End Import Libraries

# set the path to the installation folder
$XUCmd = 'C:\Program Files\XtractUniversal\xu.exe'
# XU server & port 
$XUServer = "localhost"
$XUPort = "8065"

$TableName = "MAKT"
$TableDescription = XUGet-TableDescriptionFromName $XUServer $XUPort $TableName

# $XUMetadata = XUGet-Metadata $XUServer $XUPort


clear
$inputfile = "config.xml"
$outputfile = "config.xml"
$outputfolder = "Material_Description_MAKT\"
$fullOutputPath = "$outputPath$outputfolder"
If(!(test-path $fullOutputPath))
{
      New-Item -ItemType Directory -Force -Path $fullOutputPath
}

[xml] $xdoc = get-content "$joinTableTemplatePath$inputfile"
$xdoc.Save("$fullOutputPath$outputfile") 
