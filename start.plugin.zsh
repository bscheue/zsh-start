echo "Pick an index from below:"
cat ~/.oh-my-zsh/custom/plugins/start/recent.txt

read -r index

if [[ $index =~ [0-9] ]]
then
  cd "$(cat ~/test | cut -c 3- | sed -n $(($index+1))p)"
else
  cd
fi

zshexit () { dirs -lv > ~/.oh-my-zsh/custom/plugins/start/recent.txt; }

