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

  write-host "script path = $scriptPath`n" -ForegroundColor Cyan

  return $scriptPath
}

function registerScheduledTask($taskName, $scriptPath){
  $trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay 00:00:30
  $action = New-ScheduledTaskAction -Execute "pwsh" -Argument "-File `"$scriptPath`""
  $user = "$env:USERDOMAIN\$env:USERNAME"
  $password = ""
  $counter = 0
  $maxCount = 3
  
  while ($password -eq "" -and $counter -lt $maxCount) {
    $counter++
    $securePassword = Read-Host -AsSecureString -Prompt "please enter password for $user"
    $credentials = New-Object System.Management.Automation.PSCredential ($user, $securePassword)
    $password = $credentials.GetNetworkCredential().Password

    try {
      Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -User $user -Password $password -RunLevel Highest -Force -ErrorAction Stop
    } catch [Microsoft.Management.Infrastructure.CimException] {
      if($counter -lt $maxCount){
        write-host "`npassword incorrect, please try again... ($counter/$maxCount)" -ForegroundColor Yellow
      } else {
        write-host "`nmaximum number of attempts reached ($counter/$maxCount)." -ForegroundColor Red

        quit
      }

      $password = ""
    }
  }
}

function main(){
  startup
  $taskName = "start-wsl"
  $scriptPath = getScriptPath $taskName
  registerScheduledTask $taskName $scriptPath

  write-host ""
  write-host "$taskName scheduled task registered successfully`n" -ForegroundColor Green
  
  quit
}

main