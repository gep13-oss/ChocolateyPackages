try {

    Write-ChocolateySuccess 'VS2010PremiumMsdn'
} catch {
  Write-ChocolateyFailure 'VS2010PremiumMsdn' $($_.Exception.Message)
  throw
}