function Export-DebianControlFormat {
    param(
        [object[]]$InputObject,
        $Path,
        [switch]
        $Force
    )
    $Content = ""
    $InputObject | ForEach-Object {
        $Paragraph = $_
        $Properties = $Paragraph | Get-Member -MemberType NoteProperty
        $Properties | ForEach-Object {
            $PropertyName = $_.Name
            $Content += "$($PropertyName): $($Paragraph.$PropertyName)`r`n"
        }
        $Content += "`r`n"
    }
    $PathRoot = Split-Path $Path
    if(-not (Test-Path $PathRoot)) {
        New-Item -ItemType Directory -Path $PathRoot -Force
    }
    Set-Content -Path $Path -Value $Content -Encoding utf8 -NoNewline
}