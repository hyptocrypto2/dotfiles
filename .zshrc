# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/julianbaumgartner/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
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
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
        gh
	docker
	docker-compose
	zsh-autosuggestions
	zsh-autocomplete
	colored-man-pages
)

source $ZSH/oh-my-zsh.sh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
  export EDITOR='vim'
 fi

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

## EXTRA
export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"
export GDAL_LIBRARY_PATH="/opt/local/lib/libgdal.dylib"
export GEOS_LIBRARY_PATH="/opt/local/lib/libgeos_c.dylib"
ZSH_DISABLE_COMPFIX=true


####### PERSONAL #####

XBREW_PATH="/usr/local/homebrew/bin"
BREW_PATH="/opt/homebrew/bin"
PSQL_PATH="/Applications/Postgres.app/Contents/Versions/latest/bin"
JAVA_PATH="/usr/local/homebrew/opt/openjdk/bin"

### SET RIGHT BREW PATH FOR ARCH TYPE ###
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    export PATH="$XBREW_PATH:$PATH:$PSQL_PATH:$JAVA_PATH"
    fi 
if [ "${arch_name}" = "arm64" ]; then
    export PATH="$BREW_PATH:$PATH:$PSQL_PATH:$JAVA_PATH"
    fi

#export PATH="$BREW_PATH:$PATH:$PSQL_PATH"

# useful Python C-library compliation flags
export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix zlib)/lib"
export CPPFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix zlib)/include"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


function makepr() {
        gh pr create --fill && gh pr view -w
}

function daycare() {
        cd ~/dev/daycare_owl && startenv && cd app && code .
}


function gitreb() {
	STASHED=false
	if output=$(git status --porcelain) && ! [ -z "$output" ]; then
            echo "Stashing changes"
	    STASHED=true
            git stash -q  --include-untracked
	else
            echo "Working Tree Clean"
	fi

	MAIN_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
	git fetch -q origin &&
	echo "Rebaseing on origin/$MAIN_BRANCH"
	git rebase -q  "origin/$MAIN_BRANCH"

	if "$STASHED"
	    then
    	    echo "Poping stashed changes"
            git stash pop -q
	fi

}

function makeenv() {
	virtualenv -p /usr/local/opt/python@3.8/bin/python3.8 venv &&
        source venv/bin/activate &&
        pip install ipython black isort flake8 autoflake
} 

function startenv () {
	source venv/bin/activate
}


function cleancode () {
	flake8 . &&
        isort . &&
	black . &&
}

function mkgitdir (){
	mkdir -p -- "$1" &&
	cd -P -- "$1" &&
	git init --quiet  &&
	touch .gitignore &&
	mkdir src
}

function mkcd (){
	mkdir -p -- "$1" &&
	cd -P "$1"
}

function sleeptime (){
	sudo shutdown -s now
}

function gitcom () {
        git add . &&
        git commit -m 'Update'

if [ -z "$(git status --porcelain)" ]; then 
        git reset --soft HEAD~1 &&
        git commit --all --amend --no-edit
        echo 'Commit and rebase successful'
else 
  echo 'Error! Working tree not clean.'
fi
}

# ALIAS
alias xbrew='/usr/local/Homebrew/bin/brew'
alias cdd='cd ../'
alias cddd='cd ../../'
alias cdddd='cd ../../../'
alias cat='bat'
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gr='git rebase -i HEAD~2'
alias gcu='git commit -m "Update"'
alias prettygit="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ll='exa --all --long --header'
alias ls='exa --all --long --header'
alias ltt='tree -a -s --filelimit 10'
alias lt='exa --all --long --header --inode --git --tree --level=3'
alias runserv='python manage.py runserver'
alias startenv='source venv/bin/activate'
alias ddshell='python manage.py shell_plus --print-sql --ipython'
alias dshell='python manage.py shell -i ipython'
alias c='clear'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/julianbaumgartner/Desktop/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/julianbaumgartner/Desktop/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/julianbaumgartner/Desktop/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/julianbaumgartner/Desktop/google-cloud-sdk/completion.zsh.inc'; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
