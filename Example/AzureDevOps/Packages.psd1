@{
    UpstreamMirror = 'https://cran.csiro.au' # The upstream repository to pull packages from, supports file paths and HTTP/s.
    LocalMirror = 'https://mystorageaccount-with-static-site-enabled.z24.web.core.windows.net/subdir' # The local package mirror to compare missing packages with, supports file paths and HTTP/s.
    RVersions = @('4.2', '4.3') # R versions to download packages for
    Binaries = @{ # Binaries and respective versions that should be mirrored and signed.
        'dplyr' = '1.1.2'
        'tibble' = '3.2.1'
    }
}