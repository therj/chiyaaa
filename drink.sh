#!/bin/bash


drinkTea(){
  # Write to history
  appDir=$(dirname "${0}")
  source $appDir/env.sh
  
  # --nocommit --nopush --norsync
  # --no = No to everything
  # no commit also means no push
  
  handle_flags $@
  
  historyFile="$appDir/history.txt"
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
  
  again='y'
  
  if [[ distanceFromLast -lt $((minRepeatInMinutes * 60)) ]]
  then
    read -n 99 -p "Drank again under $minRepeatInMinutes minutes? yes/no:" again
  fi
  
  again="${again,,}" #Lowercase
  
  
  if [[ $again == 'y' || $again == 'yes' ]]
  then
    again='y'
    # Increasae Count
    if [[ $doCount == 1 ]]
    then
      echo "$currentDateTime"
      echo "$currentDateTime" >> $historyFile
      
    fi
  fi
  totalCount=$(grep -o $currentYear $historyFile | wc -l )
  echo "$totalCount" > "$appDir/index.html"
  
  echo "Total: $totalCount"
  
  if [[ $again == 'y' ]]
  then
    if [[ rsyncToRemote -eq 1 ]]
    then
      echo "**Syncing to server!**"
      rsync -avz $appDir/index.html $remoteUser@$remoteIp:$remotePath
      # Add more rsync here > history?
    fi
    if [[ gitCommit -eq 1 ]]
    then
      # Have a specific branch? > checkout here
      git add index.html
      # Add a history file as well, if you're comfortable making it public (watch gitignore)
      git commit -m "${totalCount}th $unitName of $drinkName in $currentYear"
      if [[ gitPush -eq 1 ]]
      then
        echo "**Pushing to git!**"
        git push
      fi
    fi
  else
    echo "Not updated"
  fi
}


has_param() {
  local term="$1"
  shift
  for arg; do
    if [[ $arg == "$term" ]]; then
      return 0
    fi
  done
  return 1
}

handle_flags(){
  if has_param '--no' "$@"; then
    echo "Nothing"
    rsyncToRemote=0
    gitCommit=0
    gitPush=0
  fi
  
  if has_param '--nocommit' "$@"; then
    echo "No git commit"
    gitCommit=0
    
  fi
  
  if has_param '--nopush' "$@"; then
    gitPush=0
    echo "No git push"
  fi
  
  if has_param '--norsync' "$@"; then
    rsyncToRemote=0
    echo "No rsync"
  fi
  
  if has_param '--nocount' "$@"; then
    doCount=0
    echo "No count"
  fi
  
}

drinkTea $@
