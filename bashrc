#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases 
# ============

# Modified Commands
alias ls='ls --color=auto'
alias vimdiff='vimdiff -c 'set diffopt=filler,context:1000000''

# Package management
alias update_official='yaourt -Syu'
alias update_all='yaourt -Syu --aur'
alias findpkg='yaourt -Ss'
alias installpkg='yaourt -S'
alias removepkg='yaourt -Rsn'

# Shortcuts
alias storage='cd /media/Storage'
alias webserver='cd /opt/lampp/htdocs'

# Prompt Configuration 
PS1='[\u | \w]\n>> '

# Enviromental Paths
export PATH=$PATH:/home/talentedunicorn/bin:/opt/lampp

# To make minitube 1.6-1 work
export QT_PLUGIN_PATH=/usr/lib/kde4/plugins

# For separator lines in PS1
if [ -f "$HOME/.bash_ps1" ]; then

. "$HOME/.bash_ps1"

fi

