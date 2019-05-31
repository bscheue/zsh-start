hd=$(dirname ${(%):-%x})

if [ $(pwd) != $HOME ]
then
  return
fi

touch $hd/tmux_dirs.txt
touch $hd/recent_dirs.txt

cat $hd/welcome.txt

echo "Recently visited directories:"

tmux ls > $hd/tmux_dirs.txt 2> /dev/null
sessions=$?

# offset for one indexing into the alphabet using unicode
ord_offset=96

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
recent_dirs=$hd/recent_dirs.txt
recent_dirs_lines=( "${(f)mapfile[$recent_dirs]}" )
integer IDXB=1
integer recent_dirs_len=$#recent_dirs

for ITEM in $recent_dirs_lines;
do
  printf "[%d] %s\n" $(($IDXB - 1)) $ITEM
  (( IDXB++ ))
done


tmux_dirs=$hd/tmux_dirs.txt
tmux_dirs_lines=( "${(f)mapfile[$tmux_dirs]}" )
integer IDXA=1
integer tmux_sessions_len=$#tmux_dirs_lines

echo ""
if [[ $sessions != 1 ]]
then
  if [ -n "$TMUX" ]
  then
    echo "Currently in a tmux session"
  else
    echo "Running tmux sessions:"
    for ITEM in $tmux_dirs_lines;
    do
      printf "[%s] %s\n" $(chr $(($ord_offset + $IDXA))) $ITEM
      (( IDXA++ ))
    done
  fi
else
  echo "No running tmux sessions"
fi

showmarks > $hd/showmarks.txt
all_showmarks=$hd/showmarks.txt
showmarks_lines=( "${(f)mapfile[$all_showmarks]}" )
integer IDXC=1
integer showmarks_len=$#all_showmarks

if [[ -n "${ZSH_START_MARKS+1}" ]]
then
  # length of longest bookmark name length
  max_bookmark_len=$(cat $hd/showmarks.txt | cut -f -1 |
          awk '{ print length($0) " " $0; }' $file |
            sort -r -n | tail -1 | wc -m | sed 's/^[ \t]*//')
  max_bookmark_len=$(($max_bookmark_len+3))
  printf "\nBookmarks:\n"
  # TODO - fix the file path for bookmarks to be consistent with directories
  # possible solution - dirname
  for ITEM in $showmarks_lines;
  do
    bm_name=$(echo $ITEM | cut -f -1)
    jump $bm_name
    # pushd $(echo $ITEM | cut -f3
    dir=$(pwd) > /dev/null
    # echo $dir
    popd &> /dev/null
    printf "%-${max_bookmark_len}s %s\n" $(echo \[$ITEM | cut -f -1)] $dir
    (( IDXC++ ))
  done
fi

printf "\nSelect an option: "
read -r index

if [[ $index =~ [0-9] ]] && [[ $index -lt recent_dirs_len ]]
then
  printf "Going to $(cat $hd/recent_dirs.txt | sed -n $(($index + 1))p)\n"
  cd "$(cat $hd/recent_dirs.txt | sed -n $(($index + 1))p)"
elif [[ $index =~ [a-z] ]] && [[ $(($(ord $index) - $ord_offset)) -lt $tmux_sessions_len ]]
then
  tmux attach -t $(cat $hd/tmux_dirs.txt |
    sed -n $(($(ord $index) - $ord_offset))p |
      cut -d \: -f -1)
elif [[ $index =~ j[a-z] ]]
then
  echo "Jumping to bookmark '${index:1}'"
  jump ${index:1}
else
  echo "None selected"
fi


zshexit () {
  cat $hd/recent_dirs.txt | tail -r > $hd/temp
  dirs -lv | cut -c 3- | tail -r >> $hd/temp;
  # cd after, to avoid accidentally including the directory
  cd $hd;
  cat temp | tail -r | awk '!seen[$0]++' | head -n 10 > recent_dirs.txt;
  rm temp;
}

