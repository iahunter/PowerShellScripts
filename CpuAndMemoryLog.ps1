$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }

Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "     Machine CPU and Memory Log    " | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

$totalRam = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).Sum
while($true) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $cpuTime = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $availMem = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
    $log = $date + ' > CPU: ' + $cpuTime.ToString("#,0.000") + '%, Avail. Mem.: ' + $availMem.ToString("N0") + 'MB (' + (104857600 * $availMem / $totalRam).ToString("#,0.0") + '%)'
    Write-Output $log | Tee-Object -FilePath .\MachineLog-$timestamp.txt -Append
    Start-Sleep -s 2
}
