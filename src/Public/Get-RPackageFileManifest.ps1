function Get-RPackageFileManifest {
    # Path is the path to the expanded RPackage
    param($Path)
    # The MD5 file is a list of hashes and files
    # Each hash and file is on it's own line and separated by a space and an asterisk
    # For example
    # 272ff4a7828e25a67b1835cde68c1635 *help/aliases.rds
    # We will split the line at the first occurance of the space and the asterisk to construct a KV pair of files and hashes.
    # Filepath is the key, hash is the value.
    $MD5Path = Join-Path $Path "MD5"
    $Files = @{}
    Get-Content -Path $MD5Path | ForEach-Object {
        # Remove empty lines
        if([System.String]::IsNullOrEmpty($_)) {
            return
        }
        $Parts = $_.Split(" *", 2, [System.StringSplitOptions]::RemoveEmptyEntries)
        $Files.Add($Parts[1], $Parts[0])
    }
    return $Files
}