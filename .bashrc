# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacman='sudo pacman'
alias v='nvim'

# Prompt
PS1='[\u@\h \W]\$ '

# Environment variables and paths
export PATH="$HOME/.bun/bin:$PATH"
export JAVA_HOME="$HOME/.jdks/jdk-21"
export PATH="$JAVA_HOME/bin:$PATH"

# Go binaries (gopls, golangci-lint, etc.)
export PATH="$PATH:$(go env GOPATH)/bin"

# Rust cargo
. "$HOME/.cargo/env"

# Custom local bin env (if it exists and you use it)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Starship prompt (should be near the end)
eval "$(starship init bash)"

# Custom tmux function: attach or create session 'main'
tmux() {
  if [ -n "$TMUX" ]; then
    command tmux "$@"
    return
  fi
  command tmux attach -t main || command tmux new -s main
}

