# Profile startup performance
# zmodload zsh/zprof

eval "$(starship init zsh)"

setopt histignorealldups sharehistory

bindkey -v
bindkey "^?" backward-delete-char
# bindkey -r "^J"
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^[^M' self-insert-unmeta
function vi-yank-xclip {
  zle vi-yank
  echo -n "$CUTBUFFER" | xclip -selection clipboard
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip
unsetopt AUTO_REMOVE_SLASH

# Prevent Ctrl+D from exiting the shell
setopt IGNORE_EOF
# Disable Ctrl+D Zsh binding
bindkey -r "^D"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

PROMPT_EOL_MARK=''

export XDG_CONFIG_HOME="$HOME/.config"
export HOMEBREW_PREFIX='/home/linuxbrew/.linuxbrew'
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export _ZL_CD='cd'

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --border
  --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#3b4252,hl+:#A3BE8C,border:#81A1C1
  --color pointer:#3b4252,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#b1c89d,marker:#EBCB8B
  --prompt=" ❯ " --pointer="."'

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#D08770,bold'
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#BF616A,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=#88C0D0,bold,underline'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#5E81AC,bold'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#81A1C1,bold'

export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH=$PATH:"$HOMEBREW_PREFIX/bin"
export PATH=$PATH:"$HOMEBREW_PREFIX/sbin"
export PATH=$PATH:"$GOPATH/bin"
export PATH=$PATH:"$GOROOT/bin"
export PATH=$PATH:"$HOME/.pyenv/bin"
export PATH=$PATH:"$HOME/.poetry/bin"
export PATH=$PATH:"$HOME/.cargo/bin"
export PATH=$PATH:"$HOME/.surrealdb"
export PATH=$PATH:"$HOME/.local/share/flatpak/exports/bin"
export PATH=$PATH:"$HOME/.local/bin"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
export PATH=$PATH:"$PYENV_ROOT/bin"
export PATH=$PATH:"$PYENV_ROOT/shims"

alias apt='nala'
alias ll='exa -l -g --icons --group-directories-first --octal-permissions --no-filesize --time-style long-iso --no-permissions --no-user'
alias la='ll -a'
alias gs='git status -s'
alias run='./run.sh'
alias z='zed -n .'

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/doc/fzf/examples/completion.zsh

rv_precmd() {
  eval "$(rv precmd)"
}

rv_chpwd() {
  eval "$(rv chpwd)"
}

autoload -U add-zsh-hook
add-zsh-hook precmd rv_precmd
add-zsh-hook chpwd rv_chpwd

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(direnv hook zsh)"
# Profile startup performance
# zprof

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh --disable-up-arrow)"
export FLYCTL_INSTALL="/home/ch/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/ch/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
