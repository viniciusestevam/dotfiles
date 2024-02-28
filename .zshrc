export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# zinit {
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions
# }

# nvm {
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# }

# Variables {
export COLORTERM=truecolor
export EDITOR=nvim
export TERM=xterm-256color # maybe need to change this
export RC="~/dotfiles"

export GO="/usr/local/go/bin"
export PATH=$PATH:$GO
# }

# aliases {
alias vim="nvim"
alias vimcfg="vim $RC/nvim"
alias termcfg="vim $RC/kitty.conf"
alias zshcfg="vim $RC/.zshrc && source $RC/.zshrc"
alias tmuxcfg="vim $RC/.tmux.conf"
alias vimkeys="cat ~/dotfiles/nvim/lua/busco_romance/keymaps.lua"
# }

