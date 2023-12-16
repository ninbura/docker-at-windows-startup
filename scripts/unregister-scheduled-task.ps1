function startup(){
  write-host "registering scheduled task..."
}

function quit(){
  write-host('closing program, press [enter] to exit...') -NoNewLine
  $Host.UI.ReadLine()

  exit
}

function unregisterScheduledTask($taskName){
  Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

function main(){
  startup
  $taskName = "start-wsl"
  unregisterScheduledTask $taskName

  write-host "$taskName scheduled task unregistered successfully`n" -ForegroundColor Green
  
  quit
}

main