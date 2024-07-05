Function Expand-GZipFile {
    Param(
        $Path,
        $OutputPath = ($Path -replace '\.gz$', '')
    )

    $InputStream = New-Object System.IO.FileStream $Path, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read)
    try {
        $OutputStream = New-Object System.IO.FileStream $OutputPath, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None)
        try {
            $GZipStream = New-Object System.IO.Compression.GzipStream $InputStream, ([IO.Compression.CompressionMode]::Decompress)
            try {
                $Buffer = New-Object byte[](1024)
                while ($true) {
                    $Read = $gzipstream.Read($Buffer, 0, 1024)
                    if ($Read -le 0) { break }
                    $OutputStream.Write($Buffer, 0, $Read)
                }
            }
            finally {
                $GZipStream.Close()
            }
        }
        finally {
            $OutputStream.Close()
        }
    }
    finally {
        $InputStream.Close()
    }
}