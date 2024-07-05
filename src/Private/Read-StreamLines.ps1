# Read stream and output lines to pipeline
function Read-StreamLines {
    [CmdletBinding()]
    param($Stream)
    begin {
        $StreamReader = [System.IO.StreamReader]::new($Stream)
    }
    process {
        while($StreamReader.Peek() -ge 0) {
            Write-Output $StreamReader.ReadLine()
        }
    }
    end {
        if($NULL -ne $StreamReader) {
            $StreamReader.Dispose()
        }
    }
}