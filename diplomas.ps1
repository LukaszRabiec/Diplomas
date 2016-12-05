<#
.SYNOPSIS
    Simple script that downloads photos from WFAiIS UMK graduation.
.DESCRIPTION
    Author:     Lukasz Pawel Rabiec
    Date:       December 5, 2016
    Version:    0.2
.PARAMETER SaveFolder
    Catalog path for images
    Default: Script catalog + "\Diplomas2016\"
.PARAMETER Url
    Images url
    Default: http://dydaktyka.fizyka.umk.pl/fotki/Dyplomy_2016/b/
.PARAMETER Ext
    Files extension
    Default: .JPG
.EXAMPLE
    PS C:\>./diplomas.ps1
    PS C:\>./diplomas.ps1 folder http://dydaktyka.fizyka.umk.pl/fotki/Dyplomy_2016/b/ .png
#>

Param(
    $SaveFolder = $PSScriptRoot + "\Diplomas2016\",
    $Url = "http://dydaktyka.fizyka.umk.pl/fotki/Dyplomy_2016/b/",
    $Ext = ".JPG"
)

if (!(Test-Path -Path $SaveFolder))
{
    New-Item $SaveFolder -Type Directory
    Write-Host "Folder created."
}

$client = New-Object System.Net.WebClient
$regex = "\w+" + $Ext

try 
{
    $webpage = $client.DownloadString($Url)
    $webpage | Select-String -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | Select-Object -Unique | ForEach-Object {
        $client.DownloadFile($Url + $_, $SaveFolder + $_)
        Write-Host "Downloading $_"
    }
    Write-Host "Downloading completed."
}
catch [System.Exception] {
    $_.Exception.Message
}