function Update-RBinSignRepository {
    [CmdletBinding()]
    param(
        $Configuration,
        $OutputPath,
        [X509Certificate2]$Certificate
    )
    
    $UpstreamMirror = Get-RRepository -BasePath $Configuration.UpstreamMirror -RVersions $Configuration.RVersions
    $LocalMirror = Get-RRepository -BasePath $Configuration.LocalMirror -RVersions $Configuration.RVersions
    
    $AllImportResults = $Configuration.RVersions | ForEach-Object {
        $RVersion = $_
        $ImportResults = $Configuration.Binaries.Keys | Foreach-Object {
            $PackageName = $_
            $PackageVersion = $Configuration.Binaries[$_]
            Import-RPackage -Name $PackageName `
                -PackageVersion $PackageVersion `
                -RVersion $RVersion `
                -UpstreamMirror $UpstreamMirror `
                -LocalMirror $LocalMirror `
                -LocalPath $OutputPath `
                -Certificate $Certificate
        }
        # Write successful results to PACKAGES manifest
        $SuccessfulPackages = $ImportResults | Where-Object Successful -eq $TRUE | Select-Object -ExpandProperty Package
        $PackagesPath = Get-RRepositoryPath -BasePath $OutputPath -RVersion $RVersion -Packages
        $PackagesGzPath = Get-RRepositoryPath -BasePath $OutputPath -RVersion $RVersion -Packages -Gzip
        Export-DebianControlFormat -Path $PackagesPath -InputObject $SuccessfulPackages -Force
        Compress-GZipFile -Path $PackagesPath -OutFile $PackagesGzPath
        
        Write-Output $ImportResults
    }

    # Build packages file
    $SrcPackagesPath = Get-RRepositoryPath -BasePath $OutputPath -SrcPackages
    $SrcPackagesGzPath = Get-RRepositoryPath -BasePath $OutputPath -SrcPackages -Gzip
    $AllSuccessfulPackages = $AllImportResults | Where-Object Successful -eq $TRUE | Select-Object -ExpandProperty Package | Sort-Object -Unique -Property Package

    Export-DebianControlFormat -Path $SrcPackagesPath -InputObject $AllSuccessfulPackages -Force
    Compress-GZipFile -Path $SrcPackagesPath -OutFile $SrcPackagesGzPath

    return $AllImportResults
}