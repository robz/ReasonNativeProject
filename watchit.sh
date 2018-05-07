if [[ $# -ne 3 ]] ; then
  echo 'wrong number of args. For example: watchit.sh bin re "esy build"'
  exit 0
fi

watch_directory=$1
extension=$2
on_change_command=$3

watchman shutdown-server
watchman watch $watch_directory

clear
eval $on_change_command

while true; do
  watchman-wait "$watch_directory" -p "**/*.$extension"
  if [[ $? -eq 0 ]]; then
    echo '/////////////////////////////////////////////////////////////////////'
    clear
    eval $on_change_command
  else
    exit
  fi
  sleep 1
done
