function main() {
  $config = Get-Content -Path "$PSScriptRoot/../config.json" -Raw | ConvertFrom-Json
  wsl -d $config.imageName
}

main