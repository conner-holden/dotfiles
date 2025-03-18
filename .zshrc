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

export XDG_CONFIG_HOME="$HOME/.config"
export VOLTA_HOME="$HOME/.volta"

export PATH="$HOME/.atuin/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"

alias ls='eza'
alias ll="eza -l -g --group-directories-first --no-filesize --time-style iso --no-permissions --no-user --time-style '+%m/%d/%y [%H:%M]'"
alias la='ll -a'
alias cat='bat -p --theme=Nord'
alias gs='git status -s'
alias n='nvim .'

source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fpath=("$HOME/.zsh/zsh-completions" $fpath)

source <(fzf --zsh)

eval "$(atuin init zsh --disable-up-arrow)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

export PNPM_HOME="/home/ch/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
