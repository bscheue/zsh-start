# zsh-start
A simple start screen for zsh

![Example](/images/example.png)

# Installation
### Manual:
First clone this repository onto your machine. This example will use `~/.zsh/zsh-start`:
```
git clone https://github.com/bscheue/zsh-start ~/.zsh/zsh-start
```
Then, add the following to your `.zshrc`:
```
source ~/.zsh/zsh-start/start.plugin.zsh
```

### Oh My Zsh:
First, clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`):
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
Then, add this plugin to the list of plugins for Oh My Zsh to load in your `.zshrc`.

# Usage:
Use this plugin to jump to recently visited directories upon starting zsh.
Upon opening, you'll be shown your ten (distinct) most recently visited directories
numbered 0-9, along with any running tmux sessions.
Pressing a number along with enter will take you to that directory,
while pressing a character will attach to the corresponding tmux session.
Pressing any other key along with enter (or just enter itself) will continue to startup
like normal and take you to your home directory.
