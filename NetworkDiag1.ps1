# Script to run on User machine during intermitten issues. Will Do Network Diagnostic commands and output them into a file Named ProblemLog.txt in the directory where you run the script
# Run in Powershell CLI by executing .\NetworkDiag1.ps1

Write-Output "###################################"
Write-Output "  Starting Network Diagnostic Log  "
Write-Output "###################################"

$nslookups = @(
                "sip.pstnhub.microsoft.com.com",
                "google.com",
                "facebook.com",
                "apple.com"
              )


$pings = @("google.com",
            "4.2.2.2",
            "8.8.8.8")


while(1){

    $date = Get-Date 

    Write-Output $date

    # Record Date and Time
    Write-Output $date | Out-File -FilePath .\ProblemLog.txt -Append

    
    # IP Configuration
    ipconfig /all | Out-File -FilePath .\ProblemLog.txt -Append

    # Wifi Diagnostics
    netsh wlan show interface | Out-File -FilePath .\ProblemLog.txt -Append

    # DNS Checks
    ForEach ($nslookup in $nslookups) {
        Write-Output "nslookup $nslookup"
        $result = nslookup $nslookup
        $result |Tee-Object -FilePath .\ProblemLog.txt -Append

        Write-Output "nslookup $nslookup 1.1.1.1"
        $result = nslookup $nslookup 1.1.1.1
        $result |Tee-Object -FilePath .\ProblemLog.txt -Append

        Write-Output "nslookup $nslookup 8.8.8.8"
        $result = nslookup $nslookup 8.8.8.8
        $result |Tee-Object -FilePath .\ProblemLog.txt -Append
    }

    # IPv4 Internet Reachablity Checks
    ForEach ($ping in $pings) {
        Write-Output "ping $ping"
        $result = ping $ping
        $result |Tee-Object -FilePath .\ProblemLog.txt -Append

        Write-Output "tracert $ping"
        $result = tracert $ping
        $result |Tee-Object -FilePath .\ProblemLog.txt -Append

    }

    Start-Sleep -s 5
}
