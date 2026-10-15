<#
.SYNOPSIS
    Monitors devices listed in a CSV file via ping and sends email alerts on state changes.
.DESCRIPTION
    - Pings every device every 10 seconds.
    - Ignores the first 4 consecutive packet losses.
    - Marks device DOWN on the 5th consecutive failure and sends an email.
    - Sends an email when a previously DOWN device comes back UP.
    - Times shown in HH:mm:ss (no date, no IST suffix).
    - Total Downtime shown without "days" component.
.NOTES
    Version: 2.1
    CSV Columns expected: Sr. No., Device Name, IP Address, Email Address
    CSV Path  : C:\Users\HP\OneDrive\Desktop\details.csv
    Log Path  : C:\Users\HP\OneDrive\Desktop\DeviceMonitor.log
#>

# =========================================================
# CONFIGURATION
# =========================================================
$CsvPath        = "C:\Users\HP\OneDrive\Desktop\details.csv"
$LogPath        = "C:\Users\HP\OneDrive\Desktop\DeviceMonitor.log"

# Email (Sender) configuration
$SenderEmail    = "your_sendermail@gmail.com"
$SenderPassword = "YOUR_GMAIL_APP_PASSWORD"   # <-- Replace with your 16-char Gmail App Password (no spaces)
$SmtpServer     = "smtp.gmail.com"
$SmtpPort       = 587

# Monitoring
$PingIntervalSeconds = 10
$FailureThreshold    = 5     # 5th consecutive failure = DOWN
$IgnoreFirstFailures = 4     # ignore first 4 failures

# =========================================================
# HELPER FUNCTIONS
# =========================================================

function Write-Log {
    param([string]$Message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $Message" | Out-File -FilePath $LogPath -Append -Encoding UTF8
    Write-Host "$timestamp - $Message"
}

function Get-IndianTime {
    param([datetime]$Time)
    try {
        $istZone = [System.TimeZoneInfo]::FindSystemTimeZoneById("India Standard Time")
    } catch {
        $istZone = [System.TimeZoneInfo]::CreateCustomTimeZone("IST", [TimeSpan]::FromHours(5.5), "IST", "IST")
    }
    $utc = $Time.ToUniversalTime()
    $ist = [System.TimeZoneInfo]::ConvertTimeFromUtc($utc, $istZone)
    # Only time, no date, no "IST" suffix
    return $ist.ToString("hh:mm:ss tt")
}

function Send-DeviceEmail {
    param(
        [string]$To,
        [string]$Subject,
        [string]$Body
    )
    try {
        $mail = New-Object System.Net.Mail.MailMessage
        $mail.From       = New-Object System.Net.Mail.MailAddress($SenderEmail)
        $mail.To.Add($To)
        $mail.Subject    = $Subject
        $mail.Body       = $Body
        $mail.IsBodyHtml = $false

        $smtp = New-Object System.Net.Mail.SmtpClient($SmtpServer, $SmtpPort)
        $smtp.EnableSsl   = $true
        $smtp.Credentials = New-Object System.Net.NetworkCredential($SenderEmail, $SenderPassword)
        $smtp.Timeout     = 20000

        $smtp.Send($mail)
        $mail.Dispose()
        $smtp.Dispose()

        Write-Log "Email sent to $To | Subject: $Subject"
    }
    catch {
        Write-Log "ERROR sending email to $To : $($_.Exception.ToString())"
    }
}

function Test-DevicePing {
    param([string]$IPAddress)
    try {
        $ping  = New-Object System.Net.NetworkInformation.Ping
        $reply = $ping.Send($IPAddress, 3000)
        return ($reply.Status -eq 'Success')
    } catch {
        return $false
    }
}

# =========================================================
# LOAD CSV
# =========================================================
if (-not (Test-Path $CsvPath)) {
    Write-Log "CSV file not found at $CsvPath. Exiting."
    exit 1
}

$devices = Import-Csv -Path $CsvPath

# State tracking
$state = @{}
foreach ($d in $devices) {

    $devName  = $d.'Device Name'
    $devIP    = $d.'IP Address'
    $devEmail = $d.'Email Address'

    # Skip rows missing essential data
    if ([string]::IsNullOrWhiteSpace($devIP) -or [string]::IsNullOrWhiteSpace($devEmail)) {
        Write-Log "Skipping row with missing IP or Email: $devName"
        continue
    }

    $state[$devIP] = [PSCustomObject]@{
        Name             = $devName
        IPAddress        = $devIP
        Email            = $devEmail
        ConsecutiveFails = 0
        IsDown           = $false
        DownSince        = $null
    }
}

Write-Log "==== Device Monitor Started ===="
Write-Log "Loaded $($state.Count) device(s) from CSV."

# =========================================================
# MAIN LOOP
# =========================================================
while ($true) {
    foreach ($ip in @($state.Keys)) {
        $dev  = $state[$ip]
        $isUp = Test-DevicePing -IPAddress $dev.IPAddress

        if ($isUp) {
            # ---- Device responded ----
            if ($dev.IsDown) {
                $downTime  = $dev.DownSince
                $upTime    = Get-Date
                $totalDown = $upTime - $downTime
                # No "days" — only hours, minutes, seconds
                $totalStr  = "{0} hours, {1} minutes, {2} seconds" -f `
                             [int]$totalDown.TotalHours, $totalDown.Minutes, $totalDown.Seconds

                $subject = "Device UP - $($dev.Name) - $($dev.IPAddress)"
                $body = @"
Hello Team!

The following device has successfully re-established its connection:

Device Name: $($dev.Name)
Device IP: $($dev.IPAddress)
Down Time (IST): $(Get-IndianTime -Time $downTime)
Up Time (IST): $(Get-IndianTime -Time $upTime)
Total Downtime: $totalStr

Regards,
Device Monitor
"@

                Send-DeviceEmail -To $dev.Email -Subject $subject -Body $body
                Write-Log "Device UP: $($dev.Name) [$($dev.IPAddress)] | Downtime: $totalStr"

                $dev.IsDown    = $false
                $dev.DownSince = $null
            }
            $dev.ConsecutiveFails = 0
        }
        else {
            # ---- Ping failed ----
            $dev.ConsecutiveFails++
            Write-Log "Ping failed for $($dev.Name) [$($dev.IPAddress)] - Fail #$($dev.ConsecutiveFails)"

            if ($dev.ConsecutiveFails -ge $FailureThreshold -and -not $dev.IsDown) {
                $dev.IsDown    = $true
                $dev.DownSince = Get-Date

                $subject = "Device Down - $($dev.Name) - $($dev.IPAddress)"
                $body = @"
Hello Team!

The following device has lost its connection:

Device Name: $($dev.Name)
Device IP: $($dev.IPAddress)
Down Time: $(Get-IndianTime -Time $dev.DownSince)

Regards,
Device Monitor
"@

                Send-DeviceEmail -To $dev.Email -Subject $subject -Body $body
                Write-Log "Device DOWN: $($dev.Name) [$($dev.IPAddress)]"
            }
        }
    }

    Start-Sleep -Seconds $PingIntervalSeconds
}