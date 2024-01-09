#!/usr/bin/env zsh
# ----------------------------------------------------------------------------
#          FILE:  .zshrc
#   DESCRIPTION:  ZSH configuration file
#        AUTHOR:  R
# ----------------------------------------------------------------------------


# OH-MY-ZSH ------------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="R"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colours in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
HIST_STAMPS="%d/%m/%y %T"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/ Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose composer npm yarn redis-cli colored-man-pages command-not-found safe-paste last-working-dir extract dircycle colorize battery compleat zsh-completions F-Sy-H)

source $ZSH/oh-my-zsh.sh
# ----------------------------------------------------------------------------


# Config ---------------------------------------------------------------------
# term
export TERM=xterm-256color

# locale
export LANG=en_IN.UTF-8
export LANGUAGE=en_IN.UTF-8
export LC_ALL=en_IN.UTF-8

# timezone
export TZ=Asia/Kolkata

# path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:./node_modules/bin:/home/r/.cargo/bin:$PATH"

# editors
export EDITOR="vim"
export VISUAL="subl"

# ls colours
export LSCOLORS=ExFxcxdxbxexexabagacad
(( $+commands[gdircolors] )) && eval $(gdircolors ~/.dir_colors)

# grep colours
export GREP_COLOR="mt=1;32"

# display usage statistics for commands running > 5 sec.
REPORTTIME=5

# support for extended globbing at all times
setopt extended_glob

# skip duplicates in history
setopt HIST_FIND_NO_DUPS

# zsh-autosuggestions
bindkey '^[' autosuggest-clear
bindkey '^]' autosuggest-accept
bindkey '^\' autosuggest-execute
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=8
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

# history-search-multi-word
zstyle ":history-search-multi-word" highlight-color "fg=yellow,bold"
zstyle ":plugin:history-search-multi-word" active "standout"
# ----------------------------------------------------------------------------


# Completion -----------------------------------------------------------------
autoload -U compinit &&
{
    # init completion, ignoring security checks
    compinit -C

    # force rehash to have completion picking up new commands in path
    _force_rehash() { (( CURRENT == 1 )) && rehash; return 1 }
    zstyle ':completion:::::' completer _force_rehash \
                                        _complete \
                                        _ignored \
                                        _gnu_generic \
                                        _approximate
    zstyle ':completion:*'    completer _complete \
                                        _ignored \
                                        _gnu_generic \
                                        _approximate

    # fuzzy completions ( abc => abc | abc => Abc | abc => A-big-Car | abc => ABraCadabra )
    zstyle ':completion:*'    matcher-list '' \
                              'm:{a-z\-}={A-Z\_}' \
                              'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
                              'r:|?=** m:{a-z\-}={A-Z\_}'

    # speed up completion by avoiding partial globs
    zstyle ':completion:*' accept-exact '*(N)'
    zstyle ':completion:*' accept-exact-dirs true

    # cache setup
    zstyle ':completion:*' use-cache on

    # default colours for listings
    zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==1;30=1;32}:${(s.:.)LS_COLORS}")'

    # separate directories from files
    zstyle ':completion:*' list-dirs-first true

    # turn on menu selection only when selections do not fit on screen
    zstyle ':completion:*' menu true=long select=long

    # separate matches into groups
    zstyle ':completion:*:matches' group yes
    zstyle ':completion:*' group-name ''

    # always use the most verbose completion
    zstyle ':completion:*' verbose true

    # treat sequences of slashes as single slash
    zstyle ':completion:*' squeeze-slashes true

    # describe options
    zstyle ':completion:*:options' description yes

    # completion presentation styles
    zstyle ':completion:*:options' auto-description '%d'
    zstyle ':completion:*:descriptions' format $'\e[0;37m --- %d ---\e[0;0m'
    zstyle ':completion:*:messages'     format $'\e[0;37m --- %d ---\e[0;0m'
    zstyle ':completion:*:warnings'     format $'\e[0;33m --- no matches ---\e[0;0m'

    # ignore hidden files by default
    zstyle ':completion:*:(all-|other-|)files'  ignored-patterns '*/.*'
    zstyle ':completion:*:(local-|)directories' ignored-patterns '*/.*'
    zstyle ':completion:*:cd:*'                 ignored-patterns '*/.*'

    # don't complete completion functions/widgets
    zstyle ':completion:*:functions' ignored-patterns '_*'

    # don't complete uninteresting users
    zstyle ':completion:*:*:*:users' ignored-patterns adm amanda apache avahi \
      beaglidx bin cacti canna clamav daemon dbus distcache dovecot junkbust  \
      games gdm gkrellmd gopher hacluster haldaemon halt hsqldb ident ftp fax \
      ldap lp mail mailman mailnull mldonkey mysql nagios named netdump news  \
      nfsnobody nobody nscd ntp nut nx openvpn operator pcap postfix postgres \
      privoxy pulse pvm quagga radvd rpc rpcuser rpm shutdown squid sshd sync \
      uucp vcsa xfs www-data avahi-autoipd gitblit http rtkit sabnzbd usbmux  \
      sickbeard

    # Show ignored patterns if needed.
    zstyle '*' single-ignored show

    # cd style
    zstyle ':completion:*:cd:*' ignore-parents parent pwd # cd never selects the parent directory (e.g.: cd ../<TAB>)
    zstyle ':completion:*:*:cd:*' tag-order local-directories path-directories

    # kill style
    zstyle ':completion:*:*:kill:*' command 'ps -a -w -w -u $USER -o pid,cmd --sort=-pid'
    zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=1;31=1;33"

    # rm/cp/mv style
    zstyle ':completion:*:(rm|mv|cp):*' ignore-line yes

    # hostnames completion
    zstyle -e ':completion:*:hosts' hosts 'reply=(
    ${${${${(f)"$(<~/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}
    ${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*[*?]*}
    ${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}#*[[:blank:]]}}
    )'
    zstyle ':completion:*:*:*:hosts' ignored-patterns 'ip6*' 'localhost*'

    # use zsh-completions if available
    [[ -d ~/.oh-my-zsh/plugins/zsh-completions ]] && fpath=(~/.oh-my-zsh/plugins/zsh-completions/src $fpath)

    # Completion debugging
    bindkey '^Xh' _complete_help
    bindkey '^X?' _complete_debug
}
# ----------------------------------------------------------------------------


# External -------------------------------------------------------------------
# aliases
if [ -f ~/.rBuntu_aliases ]; then
    source ~/.rBuntu_aliases
fi

source ~/.profile
source ~/z.sh
# source ~/.tmuxinator/tmuxinator.zsh
# ----------------------------------------------------------------------------


# Performance ----------------------------------------------------------------
# recompile if needed
autoload -U zrecompile && zrecompile -p ~/.{zcompdump,zshrc} > /dev/null 2>&1
# ----------------------------------------------------------------------------

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

# bun completions
[ -s "/home/r/.bun/_bun" ] && source "/home/r/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
