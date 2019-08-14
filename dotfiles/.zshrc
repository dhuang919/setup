# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export FZF_BAZE="/usr/local/bin/fzf"
export PYTHONPATH=/usr/bin/python
export NVM_DIR="$HOME/.nvm"
export PYTHONDONTWRITEBYTECODE=1
export HISTTIMEFORMAT="%d/%m/%y %T "

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ll="ls -laF"

[[ $PATH != *$HOME/bin* ]] && PATH=$PATH:~/bin
[[ $PATH != *$HOME/Library/Python/2.7/bin* ]] && PATH=$PATH:~/Library/Python/2.7/bin
[[ $PATH != */usr/local/opt/gnu-getopt/bin* ]] && PATH=$PATH:/usr/local/opt/gnu-getopt/bin

if [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
    # shellcheck disable=SC1091
    source /usr/local/opt/nvm/nvm.sh
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck disable=SC1090
    source "$NVM_DIR/nvm.sh"
else
    echo "No nvm.sh file found in /usr/local/opt/nvm/ or $NVM_DIR/nvm.sh"
fi

# Config profiles
function prof {
    vim ~/.zshrc
}
function gitprof {
    vim ~/.gitconfig
}
function reprof {
    # shellcheck disable=SC1090
    source ~/.zshrc
}
function vimprof {
    vim ~/.vimrc
}
function setup {
    local setup_path="$HOME/dev/setup"
    if [[ ! -d "$setup_path" ]]; then
        echo "$setup_path doesn't exist"
    else
        cd "$setup_path"
    fi
}

# Dirs
function sbx {
    cd ~/sandbox
}
function wb {
    local wb_path="$HOME/wanderbee"
    if [[ -d "$wb_path" ]]; then
        cd "$wb_path"
    else
        echo "$wb_path doesn't exist"
    fi
}
function bb {
    local bb_path="$HOME/bionicbee"
    if [[ -d "$bb_path" ]]; then
        cd "$bb_path"
    else
        echo "$bb_path doesn't exist"
    fi
}

# Apps
function workwork {
    open /Applications/Mail.app
    open /Applications/Slack.app
    open /Applications/Calendar.app
    open /Applications/Typora.app
    open /Applications/Spotify.app
    bb
}

# Commands
function npr {
    npm run "$1"
}
function tunnel {
    bb && vagrant ssh
}
function up {
    bb && vagrant up && code
}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit

