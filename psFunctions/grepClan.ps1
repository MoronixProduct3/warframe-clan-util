Function Find-Clan {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DumpFilePath
    )
    
    begin {
        . "$PSScriptRoot\using.ps1"
        $encoding = [Text.Encoding]::ASCII
        $regex = New-Object Regex("Warlord")
    }

    process {

        # Checking arguments
        if (-not (Test-Path $DumpFilePath)) {
            throw [System.IO.FileNotFoundException] "$DumpFilePath not found."
        }
        
        [int] $chunkSize = 500000   # Corresponds to the max match size
        [long] $currentSearchIndex = 0
        [byte[]] $buffer = New-Object byte[] $($chunkSize*2)

        [string] $searchBlock = ""
        
        $matchDictionnary = New-Object 'System.Collections.Generic.Dictionary[[long],[string]]'
        
        Using-Object ($reader = New-Object System.IO.FileStream($DumpFilePath, 'Open', 'Read')) {

            while ($reader.Position -lt $reader.Length)
            {
                # Read new chunk
                $reader.Read($buffer, $chunkSize, $chunkSize) | Out-Null

                # Convert byte array to String
                $searchBlock = $encoding.GetString($buffer, 0, $buffer.Length)

                # Search for pattern
                [Text.RegularExpressions.Match] $result = $regex.Match($searchBlock)

                while ($result.Success)
                {
                    $matchDictionnary[$currentSearchIndex + $result.Index] = $result.Value

                    $result = $result.NextMatch()
                }

                # Shift Buffer
                [Array]::Copy($buffer, $chunkSize, $buffer, 0, $chunkSize)
                $currentSearchIndex += $chunkSize
            }

            Write-Host "Found items"
            Write-Host $matchDictionnary.Count
        }
    }
}