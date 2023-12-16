param(
  [string]$testRelativePath = "c:\repos\docker-at-windows-startup"
)

function getRelativePath(){
  try{
    $relativePath = $(Split-Path $PSScriptRoot -Parent)

    if($null -eq $relativePath){
      throw "Could not get relative path."
    }
  } catch {
    $relativePath = $testRelativePath
  }

  write-host "$relativePath" -ForegroundColor Magenta

  return $relativePath
}

function writeToLog($relativePath, $scriptName){
  $logPath = "$relativePath/$scriptName.log"

  if(!(test-path $logPath)){
    new-item -Path $logPath -ItemType File -Force -Verbose
  }

  $date = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  $logEntry = "[$date] - $scriptName script ran successfully.`n"

  Add-Content -Path $logPath -Value $logEntry -Verbose
}

function main() {
  $relativePath = getRelativePath
  $config = Get-Content -Path "$relativePath/config.json" -Raw | ConvertFrom-Json
  $scriptName = "start-wsl"
  writeToLog $relativePath $scriptName
  
  wsl -d $config.imageName
}

main