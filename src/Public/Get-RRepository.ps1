#$Repository = Get-RRepository -BasePath "https://cran.csiro.au" -RVersions @("4.2", "4.3")
function Get-RRepository {
    [CmdletBinding()]
    param(
        [string]$BasePath,
        [string[]]$RVersions
    )

    return [PSCustomObject]@{
        BasePath = $BasePath
        Binaries = [PSCustomObject]@{
            Windows = $RVersions | ForEach-Object -Begin { $Hashtable = @{} } -Process {
                $IsWeb = $BasePath -match "https?:\/\/"
                $PackagesPath = Get-RRepositoryPath -BasePath $BasePath -RVersion $_ -Packages -Join:(-not $IsWeb)
                Write-Information "Reading PACKAGES from $PackagesPath"

                if($IsWeb) {
                    $Request = Invoke-WebRequest -Uri $PackagesPath -SkipHttpErrorCheck
                    if($Request.StatusCode -ne "200") {
                        return
                    }
                    $Packages = Read-StreamLines -Stream $Request.RawContentStream | Import-DebianControlFormat
                } else {
                    $Packages = Get-Content $PackagesPath | Import-DebianControlFormat
                }
                $Hashtable.Add($_, $Packages)
            } -End {
                $Hashtable
            }
        }
    }
}