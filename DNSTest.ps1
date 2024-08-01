$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }

cd "$env:USERPROFILE\Downloads"

Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "  Starting Network Diagnostic Log  " | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
Write-Output "###################################" | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

Write-Output $timestamp | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

# Check DNS Queries to these.
$nslookups = @(
                "sip.pstnhub.microsoft.com",
                "google.com",
                "facebook.com",
                "apple.com"
              )

$pings = @(
            "8.8.8.8",
            "10.123.123.123")


$systemtime = systeminfo | findstr /C:“Time Zone”

Write-Output $systemtime | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append


while(1){
    $date = Get-Date 

    # Record Date and Time
    #Write-Output $date | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

    # DNS Checks
    ForEach ($nslookup in $nslookups) {
        # Use Default DNS Server
        Write-Output "nslookup $nslookup"
        
        $result = nslookup $nslookup

        #$result 

        $test = $result | Select-String -Pattern "Addresses:|Aliases:"

        #Write-Output $test

        $date = Get-Date 

        if ($test){
            $testresult = "$date $nslookup OK"
            
            #Write-Output $testresult
            $testresult | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
        }else{

            $testresult = "$date $nslookup Failed"
            
            #Write-Output $testresult | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append
            $testresult | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

            Write-Output "$date nslookup $nslookup 1.1.1.1"
            $result = nslookup $nslookup 1.1.1.1
            $result | Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

            # IPv4 Internet Reachablity Checks
            ForEach ($ping in $pings) {
                Write-Output "ping $ping"
                $result = ping $ping
                $result |Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

                #Write-Output "tracert $ping"
                #$result = tracert $ping
                #$result |Tee-Object -FilePath .\ProblemLog-$timestamp.txt -Append

            }

        }
    }


    Start-Sleep -s 5
}
