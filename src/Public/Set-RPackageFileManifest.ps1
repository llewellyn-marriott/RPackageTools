function Set-RPackageFileManifest {
    # Path is the path to the expanded RPackage
    param(
        $Path,
        $Manifest
    )
    $MD5Path = Join-Path $Path "MD5"
    # The MD5 file is a list of hashes and files
    # Each hash and file is on it's own line and separated by a space and an asterisk
    # For example
    # 272ff4a7828e25a67b1835cde68c1635 *help/aliases.rds
    # We will construct this file from the passed in hashtable
    # File is CLRF and UTF-8
    $Content = ""
    $Manifest.Keys | ForEach-Object {
        $Content += "$($Manifest[$_]) *$($_)`r`n"
    }
    Set-Content -Path $MD5Path -Value $Content -Encoding utf8 -NoNewline
}