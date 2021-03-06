# ------------
# Basics, etc…
# ------------

# Set architecture flags
export ARCHFLAGS="-arch x86_64"

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# http://brettterpstra.com/2013/03/30/a-multi-purpose-editor-variable/
export EDITOR="$HOME/Library/Scripts/editor.sh"

# Enable shims and autocompletion for rbenv.
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# ----
# Path
# ----

# Ensure user-installed binaries take precedence
export PATH=/usr/local/share/python:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc

# Sets PATH for executable scripts
export PATH="$PATH:$HOME/Library/Scripts/"

# -------
# Aliases
# -------

# Better grep.
alias grr="grep -riIn --color"

# Cane for Ruby. To be ran before all merges to master.
alias cane="bundle exec cane --abc-glob '{app,lib,spec}/**/*.rb' --style-glob '{app,lib,spec}/**/*.rb' --style-measure 120 --gte 'coverage/covered_percent,90' --no-doc"

# MEGA TEST
alias rcb="rake && cane && brakeman -q && rake jshint"

# Be nice
alias please=sudo

# List all files colorized in long format, including dot files
alias ll="ls -la ${colorflag}"

# Git stuff
# Undo a `git push`
alias gundopush="git push -f origin HEAD^:master"
# Pretty log
alias gprettylog='git log --name-only --decorate=full --pretty=fuller'
# Log Me
alias glogme='git log --name-only --decorate=full --pretty=fuller --author="Jesse"'

# IP addresses
# http://brettterpstra.com/2013/03/31/a-few-more-of-my-favorite-shell-aliases/
alias ip="curl icanhazip.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Lazy vim
alias v="vim"

# Empty the Trash on all mounted volumes and the main HDD
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# If you use Gist and the command line, you probably have “jist” installed. If not, run gem install jist and make
# your life easier. This extremely short alias is great for popping a clipboard straight to a public gist and opening
# the link in your browser.
# http://brettterpstra.com/2013/03/14/more-command-line-handiness/
alias pbgist="jist -Ppo"

# Open Chrome
alias chrome="open -a \"Google Chrome\""

# Open Safari
alias safari="open -a \"Safari\""

# http://brettterpstra.com/2013/03/31/a-few-more-of-my-favorite-shell-aliases/
# make executable
alias ax="chmod a+x"
# edit .bash_profile
alias bp="$EDITOR ~/.bash_profile"
# edit keybindings.dict
alias kb="$EDITOR ~/Library/KeyBindings/DefaultKeyBinding.dict"
# reload your bash config
alias src="source ~/.bash_profile"

# list TODO/FIX lines from the current project
alias todos="ack -n --nogroup '(TODO|FIX(ME)?):'"

# Open path in Finder
# http://brettterpstra.com/2013/02/09/quick-tip-jumping-to-the-finder-location-in-terminal/
alias f='open -a Finder ./'

# Eject drive from command line
alias eject="diskutil unmount"

# Open current directory in Sublime
alias e='subl . &'

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
alias hax="growlnotify -a 'Activity Monitor' 'System error' -m 'WTF R U DOIN'"

# ---------
# Functions
# ---------

# Custom functions here.

# JS Lint
# Reference: http://blog.simplytestable.com/installing-jslint-for-command-line-use-on-ubuntu/
function jslint {
    filename=${1##*/} # Name of file.
    dir="/Users/Jesse/Desktop/" # Directory where you want your lint files output. Must be full path. No ~.
    path="$dir$filename-lint.js"
    /usr/local/bin/node /usr/share/node-jslint/node_modules/jslint/bin/jslint.js "$1" > "$path"
}

# cd to the path of the front Finder window
cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
        cd "$target"; pwd
    else
        echo 'No Finder window found' >&2
    fi
}

# Tail console. You can pass it a string to grep on.
function console () {
    if [[ $# > 0 ]]; then
        query=$(echo "$*"|tr -s ' ' '|')
        tail -f /var/log/system.log|grep -i --color=auto -E "$query"
    else
        tail -f /var/log/system.log
    fi
}

# JS Hint
function jsh {
    HINT_FILE=app/assets/javascripts/admin/${1} rake jshint
}

# Create a new directory and enter it
function md() {
    mkdir -p "$@" && cd "$@"
}

# find shorthand
function f() {
    find . -name "$1"
}

# Syntax-highlight JSON strings or files
function json() {
    if [ -p /dev/stdin ]; then
        # piping, e.g. `echo '{"foo":42}' | json`
        python -mjson.tool | pygmentize -l javascript
    else
        # e.g. `json '{"foo":42}'`
        python -mjson.tool <<< "$*" | pygmentize -l javascript
    fi
}

# Tail system log
function console () {
    if [[ $# > 0 ]]; then
        query=$(echo "$*"|tr -s ' ' '|')
        tail -f /var/log/system.log|grep -i --color=auto -E "$query"
    else
        tail -f /var/log/system.log
    fi
}

# batch change extension
function chgext() {
    for file in *.$1 ; do mv $file `echo $file | sed "s/\(.*\.\)$1/\1$2/"` ; done
}

# Open find or dir in Alfred
# Select the current directory in launchbar, optionally a file
alf () {
    if [[ $# = 1 ]]; then
        [[ -e "$(pwd)/$1" ]] && open "x-alfred:select?file=$(pwd)/$1" || open "x-alfred:select?file=$1"
    else
        open "x-alfred:select?file=$(pwd)"
    fi
}

# Rename Tabs
# Reference: http://thelucid.com/2012/01/04/naming-your-terminal-tabs-in-osx-lion/
function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
}

# For when you get angry
function fuck () { echo "Calm down"; }
function FUCK () { echo "Calm down"; }
function FUCKFUCK () { echo "Calm down"; }

# -----------
# Bash Prompt
# -----------

# @gf3’s Sexy Bash Prompt, inspired by “Extravagant Zsh Prompt”
# Shamelessly copied from https://github.com/gf3/dotfiles

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        MAGENTA=$(tput setaf 9)
        ORANGE=$(tput setaf 172)
        GREEN=$(tput setaf 190)
        PURPLE=$(tput setaf 141)
        WHITE=$(tput setaf 256)
    else
        MAGENTA=$(tput setaf 5)
        ORANGE=$(tput setaf 4)
        GREEN=$(tput setaf 2)
        PURPLE=$(tput setaf 1)
        WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi


function parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# iTerm Tab and Title Customization and prompt customization
# http://sage.ucsc.edu/xtal/iterm_tab_customization.html

# Put the string " [bash]   hostname::/full/directory/path"
# in the title bar using the command sequence
# \[\e]2;[bash]   \h::\]$PWD\[\a\]

# Put the penultimate and current directory
# in the iterm tab
# \[\e]1;\]$(basename $(dirname $PWD))/\W\[\a\]

PS1="\n\[$RESET\]\[\e]2;$PWD\[\a\]\[\e]1;\]$(basename "$(dirname "$PWD")")/\W\[\a\]\[${BOLD}${MAGENTA}\]\u \[$WHITE\]on \[$ORANGE\]\h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$RESET\] "