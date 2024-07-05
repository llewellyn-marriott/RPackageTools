# Examples
# Get-RRepositoryPath -BasePath "C:\temp" -SrcPackages -Join
# Get-RRepositoryPath -BasePath "C:\temp" -RVersion "4.2" -Packages -Join
# Get-RRepositoryPath -BasePath "C:\temp" -RVersion "4.2" -PackageName "dplyr" -PackageVersion "1.2.3" -Join -Zip
# Get-RRepositoryPath -BasePath "C:\temp" -RVersion "4.2" -PackageName "dplyr" -PackageVersion "1.2.3" -Join
# Get-RRepositoryPath -BasePath "C:\temp" -RVersion "4.2" -Join
function Get-RRepositoryPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $BasePath,
        [Parameter(ParameterSetName = "RVersion", Mandatory = $true)]
        [Parameter(ParameterSetName = "Package", Mandatory = $true)]
        [Parameter(ParameterSetName = "Packages", Mandatory = $true)]
        $RVersion,
        [Parameter(ParameterSetName = "Package", Mandatory = $true)]
        $PackageName,
        [Parameter(ParameterSetName = "Package", Mandatory = $true)]
        $PackageVersion,
        [Parameter(ParameterSetName = "Packages", Mandatory = $true)]
        [switch]
        $Packages,
        [Parameter(ParameterSetName = "SrcPackages", Mandatory = $true)]
        [switch]
        $SrcPackages,
        [switch]
        $Zip,
        [switch]
        $MD5,
        [switch]
        $Gzip,
        [switch]
        $Join
    )

    $BinWinContrib = "bin/windows/contrib"

    $Path = switch ($PSCmdlet.ParameterSetName) {
        "RVersion" { 
            "/$BinWinContrib/$RVersion"  
        }
        "Package" { 
            "/$BinWinContrib/$RVersion/$($PackageName)_$($PackageVersion)"
        }
        "Packages" { 
            "/$BinWinContrib/$RVersion/PACKAGES"
        }
        "SrcPackages" { 
            "/src/contrib/PACKAGES"
        }
        Default { "" }
    }

    $Path += $($Zip ? '.zip' : '')
    $Path += $($MD5 ? '/MD5' : '')
    $Path += $($Gzip ? '.gz' : '')

    if($Join) {
        $Path = Join-Path -Path $BasePath -ChildPath $Path
    } else {
        $Path = "$($BasePath)$Path"
    }
    
    return $Path
    
}