try {

    Write-ChocolateySuccess 'gep13.ChocolateyServer'
} catch {
  Write-ChocolateyFailure 'gep13.ChocolateyServer' $($_.Exception.Message)
  throw
}