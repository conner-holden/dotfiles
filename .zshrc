autoload -U +X compinit && compinit

setopt IGNORE_EOF

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

PROMPT_EOL_MARK=''

export EDITOR=nvim
export XDG_CONFIG_HOME="$HOME/.config"
export VOLTA_HOME="$HOME/.volta"
export FLYCTL_INSTALL="/home/ch/.fly"

export PATH="$FLYCTL_INSTALL/bin:$PATH"
export PATH="$HOME/.atuin/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"

alias ls='eza'
alias ll="eza -l -g --group-directories-first --no-filesize --time-style iso --no-permissions --no-user --time-style '+%m/%d/%y [%H:%M]'"
alias la='ll -a'
alias cat='bat -p --theme=Nord'
alias ps='procs'
alias top='procs -w'
alias htop='btm'
alias gs='git status -s'
alias n='nvim .'

source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fpath=("$HOME/.zsh/zsh-completions" $fpath)

source <(fzf --zsh)

rv_precmd() {
  eval "$(rv precmd)"
}
rv_chpwd() {
  eval "$(rv chpwd)"
}
autoload -U add-zsh-hook
add-zsh-hook precmd rv_precmd
add-zsh-hook chpwd rv_chpwd

eval "$(atuin init zsh --disable-up-arrow)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

export PNPM_HOME="/home/ch/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
