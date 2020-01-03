#!/bin/bash


drinkTea(){
  
  # Write to history
  currentDir=$(dirname "${0}")
  source $currentDir/env.sh
  historyFile="$currentDir/history.txt"
  secondLastLine=''
  lastLine=''
  
  
  while IFS= read -r line
  do
    secondLastLine=$lastLine
    lastLine=$line
  done < "$historyFile"
  
  if [[ -z $secondLastLine &&  -z "$lastLine" ]]
  then
    echo "Could not locate last date"
    lastDateValid=0
    # exit 1
  else
    lastDateValid=1
  fi
  
  if [ -z "$lastLine" ]
  then
    lastLine=$secondLastLine
  fi
  
  day=${lastLine%% *}
  currentDateTime=$(date)
  today=${currentDateTime%% *}
  
  
  lastTimestamp=0
  currentTimestamp=$(date -d "$currentDateTime" +%s)
  
  if [[ lastDateValid -eq 1 ]]
  then
    lastTimestamp=$(date -d "$lastLine" +%s)
  fi
  
  
  if [[ $day != $today ]]
  then
    echo "Inserting new line"
    echo -e "" >> $historyFile
  fi
  
  
  distanceFromLast=$((currentTimestamp - lastTimestamp))
  
  again=y
  
  if [[ distanceFromLast -lt $((minRepeatInMinutes * 60)) ]]
  then
    read -n 99 -p "Drank again under $minRepeatInMinutes minutes? yes/no:" again
  fi
  
  again="${again,,}" #Lowercase
  
  
  totalCount=$(grep -o $currentYear $historyFile | wc -l )
  if [[ $again == 'y' || $again == 'yes' ]]
  then
    # Increasae Count
    echo "$currentDateTime" >> $historyFile
    totalCount=$(grep -o $currentYear $historyFile | wc -l )
    echo "$totalCount" > index.html
  fi
  echo "Total: $totalCount"
  
  if [[ pushToRemote == 1 ]]
  then
    echo "**Syncing to server!**"
    
    rsync -avz $(pwd)/index.html $remoteUser@$remoteIp:$remotePath
  fi
}

drinkTea
