export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions docker docker-compose ssh zig)

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:"$HOME/.local/scripts/"
bindkey -s ^f "tmux-sessionizer\n"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$(go env GOPATH)/bin

. "$HOME/.asdf/asdf.sh"
