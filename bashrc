# Bashrc by Talented Unicorn

# Enable programmable completion features.
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# Set the default editor to vim.
export EDITOR=vim

# Add bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Paths
########

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# PATH for lampp
export PATH=$PATH:/opt/lampp

# Stuff to run
##############

# dircolors
eval `dircolors ~/.dircolors`
