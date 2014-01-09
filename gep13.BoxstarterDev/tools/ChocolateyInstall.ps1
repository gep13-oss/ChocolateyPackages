try {

    Write-ChocolateySuccess 'gep13.BoxstarterDev'
} catch {
  Write-ChocolateyFailure 'gep13.BoxstarterDev' $($_.Exception.Message)
  throw
}