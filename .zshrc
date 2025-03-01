
bindkey -v
bindkey "^?" backward-delete-char
bindkey -r "^J"
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^[^M' self-insert-unmeta
function vi-yank-xclip {
  zle vi-yank
  echo -n "$CUTBUFFER" | xclip -selection clipboard
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

export XDG_CONFIG_HOME="$HOME/.config"
export FUNCNEST=100

export PATH="$HOME/.atuin/bin:$PATH"

alias ls='exa'
alias ll='exa -l -g --group-directories-first --no-filesize --time-style iso --no-permissions --no-user'
alias la='ll -a'
alias gs='git status -s'

source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

eval "$(atuin init zsh --disable-up-arrow)"
eval "$(starship init zsh)"

