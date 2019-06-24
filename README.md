# zsh-start
A simple start screen for zsh

![Example](/images/example.png)

# Installation
### Manual
First clone this repository onto your machine. This example will use `~/.zsh/zsh-start`:
```
git clone https://github.com/bscheue/zsh-start ~/.zsh/zsh-start
```
Then, add the following to your `.zshrc`:
```
source ~/.zsh/zsh-start/start.plugin.zsh
```

### Oh My Zsh
First, clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`):
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
Then, add this plugin to the list of plugins for Oh My Zsh to load in your `.zshrc`.

# Usage
Use this plugin to jump to recently visited directories upon starting zsh.
Upon opening, you'll be shown your ten (distinct) most recently visited directories
numbered `0-9`, along with any running tmux sessions lettered starting at `a`.
Pressing a number along with enter will take you to that directory,
while pressing a character will attach to the corresponding tmux session.
Pressing any other key along with enter (or just enter itself) will continue to startup
like normal and take you to your home directory.

### Options
All of the features of this plugin are optional. Disabling a feature also prevents the user from
selecting an option that corresponds to the feature (e.g. selecting `0` after disabling
recently visited directories would not be recognized as a valid input).
To turn off any of the features, add the following to your `.zshrc`:
* `ZSH_START_WELCOME_MESSAGE=0` disables the ascii art welcome message.
* `ZSH_START_RECENT=0` disables the display of recently visited directories.
* `ZSH_START_TMUX=0` disables the display of running tmux sessions.

### [`zshmarks`](https://github.com/jocelynmallon/zshmarks) Integration
To set this up, put `ZSH_START_MARKS=1` in your `.zshrc` and follow the
installation instructions for `zshmarks`.
Further, make sure that `zshmarks` is loaded before `start`
(source it first, or put it before `start` in your list of plugins).
To use the integration, type `j` in front of the name of the mark you'd like to
jump to. For example, in the above image, typing `jp` will jump to
`/Users/brian/Documents/project`.

# Notes
* The start menu isn't shown when the current directory upon startup isn't `$HOME`, as it's
typical to want to stay in the same directory in these cases (eg calling `:terminal` within
a Vim instance or splitting a pane in a tmux session).
* Current tmux sessions aren't shown when already in a tmux session.
