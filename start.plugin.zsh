echo "Pick an index from below:"
echo ""
echo "Recently visited directories"
cat ~/.oh-my-zsh/custom/plugins/start/recent_dirs.txt

echo ""
tmux ls > ~/.oh-my-zsh/custom/plugins/start/tmux_dirs.txt 2> /dev/null
sessions=$?

# https://unix.stackexchange.com/questions/92447/bash-script-to-get-ascii-values-for-alphabet
chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}


zmodload zsh/mapfile
FNAME=~/.oh-my-zsh/custom/plugins/start/tmux_dirs.txt
FLINES=( "${(f)mapfile[$FNAME]}" )
integer POS=1
integer SIZE=$#FLINES

echo $sessions
if [[ $sessions != 1 ]]
then
  if [ "$TERM" = "screen" ] && [ -n "$TMUX" ]
  then
    echo "Currently in a tmux session"
  else
    echo "Running tmux sessions:"
    for ITEM in $FLINES;
    do
      printf "[%s] %s\n" $(chr $((96 + $POS))) $ITEM
      (( POS++ ))
    done
  fi
else
  echo "No running tmux sessions"
fi

read -r index

if [[ $index =~ [0-9] ]]
then
  cd "$(cat ~/.oh-my-zsh/custom/plugins/start/recent_dirs.txt | cut -c 3- | sed -n $(($index+1))p)"
elif [[ $index =~ [a-z] ]] && [[ $(($(ord $index) - 97)) -lt $SIZE ]]
then
  tmux attach -t "$($LIST[$(($(ord $index) - 96))] | cut -d \: -f $(($(ord $index) - 96)))"
else
  echo "Nothing selected"
fi

zshexit () { dirs -lv > ~/.oh-my-zsh/custom/plugins/start/recent_dirs.txt; }

