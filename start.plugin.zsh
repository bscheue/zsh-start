cat welcome.txt

echo "Recently visited directories:"

tmux ls > ~/.oh-my-zsh/custom/plugins/start/tmux_dirs.txt 2> /dev/null
sessions=$?

# attribution for chr and ord functions:
# https://unix.stackexchange.com/questions/92447/bash-script-to-get-ascii-values-for-alphabet
chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}


zmodload zsh/mapfile
recent_dirs=~/.oh-my-zsh/custom/plugins/start/recent_dirs.txt
recent_dirs_lines=( "${(f)mapfile[$recent_dirs]}" )
integer IDXB=1
integer recent_dirs_len=$#recent_dirs

for ITEM in $recent_dirs_lines;
do
  printf "[%d] %s\n" $(($IDXB - 1)) $ITEM
  (( IDXB++ ))
done


tmux_dirs=~/.oh-my-zsh/custom/plugins/start/tmux_dirs.txt
tmux_sessions=( "${(f)mapfile[$tmux_dirs]}" )
integer IDXA=1
integer tmux_sessions_len=$#tmux_sessions

echo ""
if [[ $sessions != 1 ]]
then
  if [ "$TERM" = "screen" ] && [ -n "$TMUX" ]
  then
    echo "Currently in a tmux session"
  else
    echo "Running tmux sessions:"
    for ITEM in $tmux_sessions;
    do
      printf "[%s] %s\n" $(chr $((96 + $IDXA))) $ITEM
      (( IDXA++ ))
    done
  fi
else
  echo "No running tmux sessions"
fi

printf "\nSelect an option: "
read -r index

if [[ $index =~ [0-9] ]] && [[ $index -lt recent_dirs_len ]]
then
  printf "Going to directory [$(($index))]\n"
  cd "$(cat ~/.oh-my-zsh/custom/plugins/start/recent_dirs.txt | sed -n $(($index + 1))p)"
elif [[ $index =~ [a-z] ]] && [[ $(($(ord $index) - 97)) -lt $tmux_sessions_len ]]
then
  printf "Connecting to tmux session [$(($(ord $index) - 96))]\n"
  tmux attach -t "$($LIST[$(($(ord $index) - 96))] | cut -d \: -f $(($(ord $index) - 96)))"
else
  echo "None selected"
fi

zshexit () {
  dirs -lv | cut -c 3- >> ~/.oh-my-zsh/custom/plugins/start/recent_dirs.txt;
  # cd after, to avoid accidentally including the directory
  cd ~/.oh-my-zsh/custom/plugins/start;
  lines=`grep -c ".*" recent_dirs.txt`
  cat recent_dirs.txt |
    awk '!seen[$0]++' |
      head -n $(($lines < 10 ? lines : 10))  |
        > recent_dirs.txt;
}

