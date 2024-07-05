function Import-RPackage {
    [CmdletBinding()]
    param(
        $Name,
        $PackageVersion,
        $RVersion,
        $UpstreamMirror,
        $LocalMirror,
        $LocalPath,
        [X509Certificate2]$Certificate
    )

    $PackageResult = [PSCustomObject]@{
        Name       = $_
        Message    = ""
        Version    = $PackageVersion
        RVersion   = $RVersion
        Successful = $false
        Package    = $NULL
    }

    # Check if package exists locally
    $LocalPackage = $LocalMirror.Binaries.Windows.$RVersion | Where-Object { $_.Package -ieq $PackageName -and $_.Version -ieq $PackageVersion }
    if ($NULL -ne $LocalPackage) {
        $Message = "Package $PackageName at version $PackageVersion for R $RVersion already exists on local mirror"
        Write-Information $Message
        $PackageResult.Successful = $true
        $PackageResult.Message = $Message
        $PackageResult.Package = $LocalPackage
        return $PackageResult
    }

    # Check if package exists upstream
    $UpstreamPackage = $UpstreamMirror.Binaries.Windows.$RVersion | Where-Object { $_.Package -ieq $PackageName -and $_.Version -ieq $PackageVersion }
    if ($NULL -eq $UpstreamPackage) {
        $Message = "Package $PackageName at version $PackageVersion for R $RVersion not found in upstream manifest"
        Write-Warning $Message
        $PackageResult.Message = $Message
        return $PackageResult
    }
    Write-Information "Package $PackageName at version $PackageVersion for R $RVersion was found in upstream manifest"
    $PackageResult.Package = $UpstreamPackage
        
    $CranBinPackageUrl = Get-RRepositoryPath -BasePath $UpstreamMirror.BasePath -RVersion $RVersion -PackageName $PackageName -PackageVersion $PackageVersion -Zip
    $OutputFile = Get-RRepositoryPath -BasePath $LocalPath -RVersion $RVersion -PackageName $PackageName -PackageVersion $PackageVersion -Zip -Join

    # Download binary package
    Write-Information "Trying to download binary from $CranBinPackageUrl to $OutputFile"
    $OutputDir = Split-Path $OutputFile
    if(-not (Test-Path $OutputDir)) {
        New-Item -Path $OutputDir -ItemType Directory -Force
    }
    Invoke-WebRequest -Uri $CranBinPackageUrl -OutFile $OutputFile

    # Expand package
    $BinContrib = Get-RRepositoryPath -BasePath $LocalPath -RVersion $RVersion -Join
    $ExpandedDir = Join-Path $BinContrib $PackageName
    if (Test-Path $ExpandedDir) {
        Remove-Item $ExpandedDir -Recurse -Force
    }
    Expand-Archive -Path $OutputFile -DestinationPath $BinContrib

    # Sign all DLLs in expanded package and update MD5 file
    Set-RPackageDLLSignature -Path $ExpandedDir -Certificate $Certificate

    # Compress back into package
    Compress-Archive -Path $ExpandedDir -DestinationPath $OutputFile -Force
    # Clean up expanded package
    Remove-Item $ExpandedDir -Recurse -Force
    # Write a successful output
    $PackageResult.Successful = $true
    Write-Information "Package $PackageName at version $PackageVersion for R $RVersion was successfully imported"
    Write-Output $PackageResult
}