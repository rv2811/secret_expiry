# Get today's date..
 
$today= get-date
$expirationDate = (get-date).AddDays(3)

$subscription = Get-AzSubscription
 
foreach ($sub in $subscription){
$secretexpire = New-Object System.Collections.Generic.List[System.Object]
$kv = Get-AzKeyvault

foreach ($keyvault in $kv)  { 

$Secret = Get-AzKeyVaultSecret -VaultName $keyvault.VaultName | where-Object { $_.Expires -ne $NULL} |
    Select-Object Name, @{Name="ExpiryDate";Expression={$_.Expires}}
 

 
foreach ($sec in $Secret) {
   $secretexpirydate = [datetime]$sec.ExpiryDate
   $pendingdays = ($secretexpirydate - $today).Days
 
if ($pendingdays -le 7 -and $pendingdays -ge 0)  {
    $secretexpire+= [pscustomobject]@{
    Name = $sec.Name
    ExpiryDate = $sec.ExpiryDate
    PendingDays = $pendingdays
    }
  }
}
if ($secretexpire -ne $null ){
 
$table = $secretexpire.GetEnumerator()  | ConvertTo-Html -Fragment -As Table
 
# HTML Body
 
$EmailBody = @"
<p>Dear User,<br> Please Find below secerets expiring within 7 Days.</p>
<br>

<table style="width: 68%" style="border-collapse: collapse; border: 1px solid #008080;">
<tr>
<td bgcolor="#008080" style="color: #FFFFFF; font-size: large; height: 35px;"> 
        Secrets expiring within 7 Days 
</td>
</tr>
<tr style="border-bottom-style: solid; border-bottom-width: 1px; padding-bottom: 1px">
<td style="width: 100%; height: 35px"> $table </td>
</tr>
</table>
"@
 
 
$emailSmtpServer = "smtp.gmail.com"
$emailSmtpServerPort = "587"
$emailSmtpUser = "aptestsmtp719"
$emailSmtpPass = "ruxb gsxb gpwm hokm"
# recipient 
$emailFrom = "aptestsmtp719@gmail.com"
$emailTo = "aptestsmtp719@gmail.com"
# message
$emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
$emailMessage.Subject = "Secrets Expiring in 7 Days"
$emailMessage.IsBodyHtml = $true
$emailMessage.Body = $EmailBody
#client 
$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
$SMTPClient.EnableSsl = $True
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
$SMTPClient.Send( $emailMessage )
 
}


}


}
 
 # Get Secrets

 
