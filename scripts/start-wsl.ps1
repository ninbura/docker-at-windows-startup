function writeToLog(){
  $logPath = "$PSScriptRoot/../start-wsl.log"

  if(!(test-path $logPath)){
    new-item -Path $logPath -ItemType File -Force -Verbose
  }

  $date = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  $logEntry = "[$date] - Script has run successfully.`n"

  Add-Content -Path $logPath -Value $logEntry -Verbose
}

function main() {
  $config = Get-Content -Path "$PSScriptRoot/../config.json" -Raw | ConvertFrom-Json
  
  wsl -d $config.imageName

  writeToLog
}

main