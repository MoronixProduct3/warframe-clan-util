Function Find-Clan {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DumpFilePath
    )
    
    begin {
        . "$PSScriptRoot\using.ps1"
    }

    process {

        # Checking arguments
        if (-not (Test-Path $DumpFilePath)) {
            throw [System.IO.FileNotFoundException] "$DumpFilePath not found."
        }

        [int] $chunkSize = 500000   # Corresponds to the max match size
        [long] $currentSearchIndex = 0
        [byte[]] $buffer = New-Object byte[] $($chunkSize*2)

        [string] $searchBlock

        $MatchDictionnary = New-Object 'System.Collections.Generic.Dictionary[[long],[string]]'

        Using-Object ($reader = New-Object System.IO.FileStream($DumpFilePath, 'System.IO.FileMode.Open', 'System.IO.FileAccess.Read'))
        {
            Write-Host $reader.Length
        }
    }
}