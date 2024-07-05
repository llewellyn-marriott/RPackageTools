param(
    [Parameter(Mandatory = $true)][string]$ManifestPath,
    [Parameter(Mandatory = $true)][string]$CertificatePath,
    [Parameter(Mandatory = $true)][string]$CertificateSecret,
    [Parameter(Mandatory = $true)][string]$OutputPath
)
$SecureSecret = ConvertTo-SecureString -String $CertificateSecret -AsPlainText -Force
$Certificate = Get-PfxData -FilePath $CertificatePath -Password $SecureSecret
$Certificate = $Certificate.EndEntityCertificates[0]
$Configuration = Get-RBinSignManifest -Path $ManifestPath
Update-RBinSignRepository -Configuration $Configuration -Certificate $Certificate -OutputPath $OutputPath