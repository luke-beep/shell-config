$extensions = @('dll', 'exe', 'msc', 'cpl')
$paths = @('C:\Windows', 'C:\Windows\System32', 'C:\Windows\SysWOW64')
$results = @()

foreach ($path in $paths) {
    foreach ($extension in $extensions) {
        Get-ChildItem -Path $path -File -Filter "*.$extension" | ForEach-Object {
            $fileInfo = New-Object PSObject -Property @{
                'Name' = $_.Name
                'Description' = $_.VersionInfo.FileDescription
                'Path' = $path
                'Extension' = $extension
            }
            $results += $fileInfo # Performance issues with +=, but it's fine for this use case
        }
    }
}

$results | ConvertTo-Json | Out-File "C:\common_files.json"