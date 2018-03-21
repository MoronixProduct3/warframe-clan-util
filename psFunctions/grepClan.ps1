Function Find-Clan {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DumpFilePath
    )
    
    begin {
        . "$PSScriptRoot\using.ps1"
        $encoding = [Text.Encoding]::ASCII
        $regex = New-Object Regex('(?:"_id":{"\$oid":"\w{24}"},)?"Name":"[\w-_. ]{1,24}","Creator":(?:true|false),"Members":\[(?:{(?:(?:"_id":{"\$oid":"\w{24}"}|"DisplayName":"[\w-_. ]{1,24}"|"LastLogin":{"\$date":{"\$numberLong":"\d{13}"}}|"Rank":\d{1,2}|"Status":\d+|"Joined":{"\$date":{"\$numberLong":"\d{13}"}}|"ActiveAvatarImageType":"(?:\/\w+)+"|"PlayerLevel":\d{1,2}),?){7,8}},?){1,1000}],?(?:(?:"Ranks":\[(?:{"Name":"[/\w-_. ]+","Permissions":\d+},?)+]|"Tier":\d+|"XP":\d+|"XpCacheExpiryDate":{"\$date":{"\$numberLong":"\d{13}"}}|"IsContributor":(?:true|false)|"NumContributors":\d+),?)*')
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

                # Show progress every 10 chunks
                if ($currentSearchIndex % ($chunkSize * 10) -eq 0)
                {
                    $progress = ($reader.Position/$reader.Length)*100
                    Write-Progress -Activity "Parsing: $DumpFilePath" -Status "Found matching expressions: $($matchDictionnary.Count)" -PercentComplete $progress -CurrentOperation "Position: $($reader.Position)/$($reader.Length) ($([int]$progress) %)"
                }
            }
        }

        return $matchDictionnary
    }
}