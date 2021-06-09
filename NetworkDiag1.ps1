# Script to run on User machine during intermitten issues. Will Do Network Diagnostic commands and output them into a file Named ProblemLog.txt in the directory where you run the script
# Run in Powershell CLI by executing .\NetworkDiag1.ps1 or run in Powershell ISE by typing powershell_ise.exe

$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }

Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "  Starting Network Diagnostic Log  " | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

Write-Output $timestamp | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

# Domains we want to querie for DNS Checks
$nslookups = @(
                "sip.pstnhub.microsoft.com",
                "google.com",
                "facebook.com",
                "apple.com"
              )

# Domains and IPs we want to check connectivity to
$pings = @("google.com",
            "4.2.2.2",
            "8.8.8.8")

# Loop until we cancel
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

    # IPv4 Internet Reachablity Checks
    ForEach ($ping in $pings) {
        Write-Output "ping $ping"
        $result = ping $ping
        $result |Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

        # If Ping Times out then do a Traceroute
        $regex = "Request timed out."
        if($result -match $regex){
            Write-Output "tracert $ping"
            $result = tracert $ping
            $result |Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
        }
    }

    Start-Sleep -s 5
}
