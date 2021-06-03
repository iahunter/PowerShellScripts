# Script to run on User machine during intermitten issues. Will Do Network Diagnostic commands and output them into a file Named ProblemLog.txt in the directory where you run the script
# Run in Powershell CLI by executing .\NetworkDiag1.ps1

Write-Output "###################################"
Write-Output "  Starting Network Diagnostic Log  "
Write-Output "###################################"

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
    nslookup sip.pstnhub.microsoft.com.com | Out-File -FilePath .\ProblemLog.txt -Append
    nslookup google.com | Out-File -FilePath .\ProblemLog.txt -Append
    nslookup facebook.com | Out-File -FilePath .\ProblemLog.txt -Append
    nslookup apple.com | Out-File -FilePath .\ProblemLog.txt -Append

    # IPv4 Internet Reachablity Checks
    ping 4.2.2.2 | Out-File -FilePath .\ProblemLog.txt -Append
    ping 8.8.8.8 | Out-File -FilePath .\ProblemLog.txt -Append
    ping google.com | Out-File -FilePath .\ProblemLog.txt -Append

    # Tracroute 
    tracert 4.2.2.2 | Out-File -FilePath .\ProblemLog.txt -Append
    tracert 8.8.8.8 | Out-File -FilePath .\ProblemLog.txt -Append
    tracert google.com | Out-File -FilePath .\ProblemLog.txt -Append
    
    # Sleep
    Start-Sleep -s 5
}
