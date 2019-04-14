function Read-Config {
    if (Test-Path env:MAIL_HELPER_CONFIG) {
        Write-Verbose "Config Exists."
        $mail = Get-Content -Raw -Path $env:MAIL_HELPER_CONFIG | ConvertFrom-Json 
        return $mail
    }
    else {
        Write-Error "Config Does Not Exists.Please Add your config file path in MAIL_HELPER_CONFIG ENV variable."`
            -ErrorAction Stop
    }
}

function Send-CsvToMail {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter Path for the File to send",
            Position = 0)]
        [String]  $Path,
        [Parameter( HelpMessage = "Enter Receipient Address")]
        [String]  $To,
        [Parameter( HelpMessage = "Enter Email Subject")]
        [String]  $Subject
    )
    $mail = Read-Config
    if ($null -eq $mail) {
        Write-Error "Mail Erorr" -ErrorAction Stop
    }
    $From = $mail.From
    if ($To -eq '') {
        $To = $mail.To
    }
    if ($Subject -eq '') {
        $Subject = $mail.Subject
    }
    $Head = @"
<style>
table {
    margin: 1em auto;
    border-collapse: collapse;
    font-family: Calibri, sans-serif;
    border:none;
  }
th {
    background-color: #000000;
    font-weight:700;
    color: #fff;
    padding: 4px 8px;
    text-transform: capitalize;
    text-align:left;
    
  }
  tr {
    border-color: #000000;
    border-width: 1px;
    border-style: solid;
  }
  tr,td{
    padding: 4px 8px;
   
  }

</style>
"@ 

    try {
        $Body = Import-Csv $Path | ConvertTo-Html -Head $Head | Out-String
        $SMTPServer = $mail.SMTPServer
        $SMTPPort = $mail.SMTPPort
        $Credential = Get-StoredCredential -Target $mail.Target
        Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body `
            -BodyAsHtml -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
            -Credential $Credential -DeliveryNotificationOption OnSuccess
        Write-Verbose "Mail Send"
    }
    catch {
        $_
        
    }
}