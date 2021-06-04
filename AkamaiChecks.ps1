$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }

Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "  Starting Network Diagnostic Log  " | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

Write-Output $timestamp | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

$nslookups = @(
                "sip.pstnhub.microsoft.com.com",
                "google.com",
                "facebook.com",
                "apple.com"
              )


$pings = @("google.com",
            "4.2.2.2",
            "8.8.8.8")

$systemtime = systeminfo | findstr /C:“Time Zone”

Write-Output $systemtime | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append


while(1){

    $date = Get-Date 

    # Record Date and Time
    Write-Output $date | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    # IP Configuration
    ipconfig /all | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    # Wifi Diagnostics
    netsh wlan show interface | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append


    # DNS Checks
    ForEach ($nslookup in $nslookups) {
        # Use Default DNS Server
        Write-Output "nslookup $nslookup"
        $result = nslookup $nslookup
        $result | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

        # Use Static External DNS Server
        Write-Output "nslookup $nslookup 1.1.1.1"
        $result = nslookup $nslookup 1.1.1.1
        $result | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

        # Use Static External DNS Server
        Write-Output "nslookup $nslookup 8.8.8.8"
        $result = nslookup $nslookup 8.8.8.8
        $result | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    }

    # Domains Requested by Akamai
    $akamai = @("identity.answerx-liveness.net",
        "whoami.ipv4.akahelp.com",
        "www.espn.com")

    # Akamai Checks
    ForEach ($check in $akamai) {
        $date = Get-Date 

        # Record Time
        Write-Output $date | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

        Write-Output "nslookup -type=TXT $check 23.216.52.11"
        $result = nslookup -type=TXT $check 23.216.52.11
        $result | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

        Write-Output "nslookup -type=TXT $check 23.216.53.11"
        $result = nslookup -type=TXT $check 23.216.53.11
        $result | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

        Write-Output "nslookup -type=TXT $check"
        $result = nslookup -type=TXT $check
        $result | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
    }

    # IPv4 Internet Reachablity Checks
    ForEach ($ping in $pings) {
        Write-Output "ping $ping"
        $result = ping $ping
        $result |Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

        Write-Output "tracert $ping"
        $result = tracert $ping
        $result |Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    }

    # Netstat Checks
    $result = netstat -a -o

    #$result = netstat -a -o -b # Requires Elevation
    $result | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    Start-Sleep -s 5
}
