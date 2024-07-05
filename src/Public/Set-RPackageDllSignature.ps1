function Set-RPackageDllSignature {
    param(
        [string]$Path,
        [X509Certificate2]$Certificate
    )
    $Manifest = Get-RPackageFileManifest -Path $Path
    # Get all DLLs from manifest
    $Hashes = @{}
    $Manifest.Keys | Where-Object { $_ -like "*.dll" } | Foreach-Object {

        $DllPath = Join-Path $ExpandedDir $_
    
        # Sign the DLL
        Set-AuthenticodeSignature -FilePath $DllPath -Certificate $Certificate
    
        # Calculate the hash
        $CalculatedHash = Get-FileHash -Path $DllPath -Algorithm MD5 | Select-Object -ExpandProperty Hash
        #Set the manifest hash to the new one after signing
        # Manifest hashes seem to be lowercase, this may not matter but I will convert to lowercase just to be sure.
        $Hashes[$_] = $CalculatedHash.ToLower()
    }
    $Hashes.Keys | ForEach-Object {
        $Manifest[$_] = $Hashes[$_]
    }
    # Write the manifest
    Set-RPackageFileManifest -Path $Path -Manifest $Manifest
}