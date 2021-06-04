$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }

# Collect these files from user Machine Manually
$file = "c:\windows\logs\ETP_client.log"
$exists = Test-Path -Path $file -PathType Leaf
$servers = @()
if($exists)
{
    Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
    Write-Output "     Collecting ETP Log            " | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
    Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    $etplog = Get-Content -Path $file
    Write-Output $etplog | Out-File -FilePath .\ProblemLog-$timestamp.txt -Append

    Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
    Write-Output "     Collecting ETP Log Summary    " | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
    Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    $regex = 'attempting to send data to'
    $errors = 'DNS_ERROR'
    $akamaiServers = @()
    foreach($line in $etplog) {
        if($line -match $errors){
            Write-Output $line | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
        }

        if($line -match $regex){
            # Work here
            $array = $line.Split(" ")
            #Write-Output $line | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
            $newserver = $array | Select-Object -Last 1
            #Write-Output $server
            if($newserver -ne $server)
            {
                $d = $array[0]
                $t = $array[1]
                $server = $newserver

                if(-Not ($akamaiServers -contains $server)){
                    $akamaiServers += $server
                }
                
                Write-Output "$d $t | Akamai Server Change Detected: $server" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

            }
        }
    }

    
    foreach($server in $akamaiServers){
        $array = $server.Split("%")
            $servers += $array[0]
    }
    Write-Output $servers
}


# Collect these files from user Machine Manually
$file = "c:\windows\logs\EtpClientDiagnostics"
$exists = Test-Path -Path $file -PathType Leaf
if($exists)
{
    Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
    Write-Output "  Collecting ETP Diagnostic Log    " | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
    Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    $etplog = Get-Content -Path $file
    Write-Output $etplog | Out-File -FilePath .\ProblemLog-$timestamp.txt -Append
}



Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "  Starting Network Diagnostic Log  " | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

Write-Output $timestamp | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

# Check DNS Queries to these.
$nslookups = @("kiewit.service-now.com",
                "telecom.kiewitplaza.com",
                "sip.pstnhub.microsoft.com.com",
                "google.com",
                "facebook.com",
                "apple.com")

# Check DNS Queries to these.
$nslookups = @(
                "sip.pstnhub.microsoft.com.com",
                "google.com",
                "facebook.com",
                "apple.com"
              )

# Check Connectivity to these.
$pings = @("google.com",
            "4.2.2.2",
            "8.8.8.8")

# Add the Akamai Servers our Client is using to the Connectivity Checks
if($servers.count -gt 0){
    $pings += $servers
}


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
