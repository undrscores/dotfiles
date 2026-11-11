# $ZDOTDIR/.zshrc (ZDOTDIR=~/.config/zsh, set in ~/.zshenv)

# --- Greeting: fastfetch in each new top-level terminal (set NO_FETCH=1 to skip) ---
# Runs before the p10k instant-prompt block so its output doesn't trigger p10k's console-output warning.
if [[ -o interactive && -t 1 && $SHLVL -le 1 && -z $NO_FETCH && -z $TMUX ]] && (( $+commands[fastfetch] )); then
  fastfetch
fi

# Enable p10k instant prompt. Keep this block at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt SHARE_HISTORY EXTENDED_HISTORY

# --- Shell behavior ---
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS EXTENDED_GLOB NO_BEEP

# --- Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh/compcache

# --- Keybindings ---
bindkey -e
bindkey '^[[A' history-beginning-search-backward   # up: prefix search
bindkey '^[[B' history-beginning-search-forward    # down
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word                     # ctrl+right
bindkey '^[[1;5D' backward-word                    # ctrl+left

# --- Prompt: powerlevel10k (run `p10k configure` to restyle) ---
source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f $ZDOTDIR/.p10k.zsh ]] && source $ZDOTDIR/.p10k.zsh

# --- Tell the terminal the working directory (OSC 7): foot's ctrl+shift+n opens in the same dir ---
_osc7_cwd() {
  local LC_ALL=C
  printf '\e]7;file://%s%s\e\\' "$HOST" "${PWD//(#m)[^a-zA-Z0-9\/_.~-]/%${(l:2::0:)$(([##16]#MATCH))}}"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _osc7_cwd

# --- Aliases ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --git --group-directories-first'
alias la='eza -la --icons --git --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --paging=never'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias v='nvim'

# --- fzf (ctrl+r history, ctrl+t files, alt+c cd) ---
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# --- ushell theme: ANSI-index colors follow the wallpaper-generated palette ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --info=inline --prompt='❯ ' --pointer='▍' --marker='●' \
  --color=fg:7,bg:-1,hl:4,fg+:7,bg+:8,hl+:4,info:3,prompt:4,pointer:4,marker:2,spinner:5,header:6,border:8,gutter:-1"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || eza --tree --icons --level=2 --color=always {}' --preview-window=right:55%:border-left"
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --level=2 --color=always {}'"
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
export BAT_THEME=ansi
export EZA_COLORS="da=36:uu=34:gu=34:sn=32:sb=32:di=34;1"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%F{4}%B── %d ──%b%f'
zstyle ':completion:*:warnings' format '%F{1}no matches%f'
zstyle ':completion:*' menu select
# syntax highlighting in palette colors (applied after the plugin loads, below)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=2'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=2'
ZSH_HIGHLIGHT_STYLES[alias]='fg=2'
ZSH_HIGHLIGHT_STYLES[function]='fg=2'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=2,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=1'
ZSH_HIGHLIGHT_STYLES[path]='fg=7,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=5'
ZSH_HIGHLIGHT_STYLES[comment]='fg=8'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=4'

# --- Optional tools, loaded only if installed ---
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
for f in ~/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
         ~/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -f $f ]] && source $f      # syntax-highlighting must be sourced last
done


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
