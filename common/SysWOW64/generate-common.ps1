$extensions = @('dll', 'exe', 'msc', 'cpl')
$path = 'C:\Windows\SysWOW64'

foreach ($extension in $extensions) {
    Get-ChildItem -Path $path -File -Filter "*.$extension" | ForEach-Object { "$($_.Name) - $($_.VersionInfo.FileDescription)" } | Out-File "C:\common_$extension.txt"
}