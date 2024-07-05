# DCF (Debian Control Format) is a line based text format.
# This function reads in lines and then outputs "paragraphs" as objects of type PSCustomObject
function Import-DebianControlFormat {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string]$Line
    )

    begin {
        $CurrentField = $null
        $CurrentValue = ""
        $CurrentParagraph = @{}
    }

    process {
        Write-Debug "Reading Line: $_"

        # ignore comments
        if ($_ -match '^\#.*') { 
            Write-Debug "Ignoring comment"
            return 
        }

        # If it's a new field
        if ($_ -match '^(\S+):\s*(.*)') {
            Write-Debug "Matched field"
            if ($null -ne $CurrentField) {
                Write-Debug "New field match, outputting last $($CurrentField): $CurrentValue"
                $CurrentParagraph.Add($CurrentField, $CurrentValue)
                $CurrentField = $null
                $CurrentValue = ""
            }

            $CurrentField = $matches[1]
            $CurrentValue = $matches[2]
            return 
        }

        # If it's a continuation line
        if ($_ -match '^\s+(.*)') {
            Write-Debug "Matched continuation"
            $CurrentValue += " " + $matches[1]
            return
        }

        # Blank line
        if($_.Length -eq 0) {
            Write-Debug "Blank line"
            if ($NULL -ne $CurrentField) {
                Write-Debug "Outputting last field"
                $CurrentParagraph.Add($CurrentField, $CurrentValue)
                $CurrentField = $null
                $CurrentValue = ""
            }
            Write-Output ([PSCustomObject]$CurrentParagraph)
            $CurrentParagraph = @{}
        }
    }
    end {
        if ($NULL -ne $CurrentField) {
            Write-Debug "EOF Outputting last field"
            $CurrentParagraph.Add($CurrentField, $CurrentValue)
            $CurrentField = $null
            $CurrentValue = ""
        }
        Write-Output ([PSCustomObject]$CurrentParagraph)
    }
}
