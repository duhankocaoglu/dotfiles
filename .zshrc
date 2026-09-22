# Tab completion
autoload -Uz compinit
compinit

# Command history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Suggestions from history
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
