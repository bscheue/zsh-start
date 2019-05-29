echo "Pick an index from below:"
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
LIST="${mapfile[$FNAME]}" # Not required unless stuff uses it
integer POS=1             # Not required unless stuff uses it
integer SIZE=$#FLINES     # Number of lines, not required unless stuff uses it

echo $sessions
if [[ $sessions != 1 ]]
then
  echo "Running tmux sessions:"
  # cat ~/.oh-my-zsh/custom/plugins/start/tmux_dirs.txt
  for ITEM in $FLINES;
  do
      # Do stuff
      echo `chr $((96 + $POS))`
      echo $ITEM
      (( POS++ ))
  done
else
  echo "No running tmux sessions"
fi

read -r index

if [[ $index =~ [0-9] ]]
then
  cd "$(cat ~/.oh-my-zsh/custom/plugins/start/recent_dirs.txt | cut -c 3- | sed -n $(($index+1))p)"
elif [[ $index =~ [a-z] ]]
then
  # echo "${FLINES[1]}"
  # echo $SIZE
  # cd
  tmux attach -t "$($LIST[$(($(ord $index) - 96))] | cut -d \: -f $(($(ord $index) - 96)))"
else
  cd
fi

zshexit () { dirs -lv > ~/.oh-my-zsh/custom/plugins/start/recent_dirs.txt; }

