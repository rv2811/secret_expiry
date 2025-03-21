#Connect-AzAccount -Identity
$PSEmailServer = "smtp.gmail.com"
$allsub = Get-AzSubscription
$expiringSecrets = @()
$output = @()

$todaydate = Get-Date

foreach ($subscription in $allsub) {
    
    Set-AzContext -SubscriptionId a105df11-a901-4d46-84de-aba178a3da63
    
   $allkeyvault = Get-AzKeyVault
    
    foreach ($keyVault in $allkeyvault) {
    $output = @( 
        
        $keyvaultsecrets = Get-AzKeyVaultSecret -VaultName $keyVault.VaultName | Select-Object VaultName, Name, Expires

        foreach ($secret in $keyvaultsecrets) {
            
            if ($secret.Expires) {
                try {
                    
                    $secretexpirydate = [datetime]$secret.Expires
                    $pendingdays = ($secretexpirydate - $todaydate).Days
                    
                      
                    if ($pendingdays -le 7 -and $pendingdays -ge 0) {
                        Write-Output "Secret '$($secret.Name)' in Vault '$($keyVault.VaultName)' is going to expire within 7 days, Expiration Date: $secretexpirydate." 
                    } elseif ($pendingdays -gt 7) {
                        Write-Output "Secret '$($secret.Name)' in Vault '$($keyVault.VaultName)' is not expiring within the next 7 days. Expiration Date: $secretexpirydate." 
                    } else {
                        Write-Output "Secret '$($secret.Name)' in Vault '$($keyVault.VaultName)' has already expired or is expired. Expired on $secretexpirydate." 
                    } 
                } catch {
                    Write-Output "Invalid expiry date format for secret '$($secret.Name)' in Vault '$($keyVault.VaultName)'."
                }
            } else {
                Write-Output "No Expiry Date: Secret '$($secret.Name)' in Vault '$($keyVault.VaultName)' does not have an expiration date set."
            }
        } )
    }
}
   

   Write-Host ($output -join "`n")

   $sendMailMessageSplat = @{
    From = 'ravi <ravi8511002963@gmail.com>'
    To = 'ankit <sutharravik5@gmail>'
    Subject = 'Test mail'
    Credential = ('ravi8511002963','rrzh vgcv qvrc fjgm')
    UseSsl = $true
    Port= 587


}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Send-MailMessage @sendMailMessageSplat

  
#Send-MailMessage -SmtpServer '<ip of email relay>' -To '<employee email>' -From '<central email>' -Subject 'test' -Body 'this is a test' -Port 25