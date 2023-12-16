function startup(){
  write-host "registering scheduled task..."
}

function quit(){
  write-host('closing program, press [enter] to exit...') -NoNewLine
  $Host.UI.ReadLine()

  exit
}

function getScriptPath($taskName){
  $scriptPath = "$PSScriptRoot/$taskName.ps1"

  write-host "script path = $scriptPath" -ForegroundColor Cyan

  return $scriptPath
}

function registerScheduledTask($taskName, $scriptPath){
  Register-ScheduledTask -TaskName $taskName -Trigger (New-ScheduledTaskTrigger -AtStartup) -Action (New-ScheduledTaskAction -Execute "pwsh" -Argument "-WindowStyle Hidden -Command `"& `"$scriptPath`"`"") -RunLevel Highest -Force;
}

function main(){
  startup
  $taskName = "start-wsl"
  $scriptPath = getScriptPath $taskName
  registerScheduledTask $taskName $scriptPath

  write-host "$taskName scheduled task registered successfully`n" -ForegroundColor Green
  
  quit
}

main