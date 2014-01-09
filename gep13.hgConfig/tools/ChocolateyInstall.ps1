try {

    Write-ChocolateySuccess 'gep13.hgConfig'
} catch {
  Write-ChocolateyFailure 'gep13.hgConfig' $($_.Exception.Message)
  throw
}