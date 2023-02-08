#source aliases
source ~/.aliases

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
    docker
    1password
    ansible
    aws
    brew
    iterm2
    vscode
    common-aliases
    zsh-syntax-highlighting
    zsh-autosuggestions
)

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
eval "$(starship init zsh)"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Created by `pipx` on 2022-07-19 15:38:03
export PATH="$PATH:/Users/jessenia/.local/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function aws-reset-env {
     unset AWS_ACCESS_KEY_ID
     unset AWS_SECRET_ACCESS_KEY
     unset AWS_SECURITY_TOKEN
     unset AWS_SESSION_TOKEN
     unset AWS_SESSION_EXPIRY
     unset AWS_ASSUMED_ROLE_ID
     unset AWS_ASSUMED_ROLE_ARN
}

 # Shows all AWS credential related env variables
 function aws-show-env {
     echo AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
     echo AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
     echo AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN
     echo AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
     echo AWS_SESSION_EXPIRY=$AWS_SESSION_EXPIRY
     echo AWS_ASSUMED_ROLE_ID=$AWS_ASSUMED_ROLE_ID
     echo AWS_ASSUMED_ROLE_ARN=$AWS_ASSUMED_ROLE_ARN
 }

# Start an MFA-authenticated session for your main IAM user (not a role) and obtain temporary session credentials
 # Usage: aws-mfa-session <6 digit MFA code>
 function aws-mfa-session {
    if [[ "$AWS_ENV" == "prod" ]]
    then
     STS_CREDS=$(aws sts get-session-token --serial-number arn:aws:iam::966761610288:mfa/jessenia --token-code $AWS_MFA --output json)
    else
     STS_CREDS=$(aws sts get-session-token --serial-number arn:aws:iam::078680268262:mfa/jessenia --token-code $AWS_MFA --output json)
    fi

     if [ "$?" -eq "0" ]
     then
         export AWS_ACCESS_KEY_ID=$(echo $STS_CREDS | jq -r '.Credentials.AccessKeyId')
         export AWS_SECRET_ACCESS_KEY=$(echo $STS_CREDS | jq -r '.Credentials.SecretAccessKey')
         export AWS_SECURITY_TOKEN=$(echo $STS_CREDS | jq -r '.Credentials.SessionToken')
         export AWS_SESSION_TOKEN=$(echo $STS_CREDS | jq -r '.Credentials.SessionToken')
         export AWS_SESSION_EXPIRY=$(echo $STS_CREDS | jq -r '.Credentials.Expiration')
     else
         echo "Error: Failed to obtain temporary credentials."
     fi
 }


 # Show who you are according to AWS
 function aws-whoami {
     aws sts get-caller-identity
 }


 # Usage: aws-switch-production <6 digit MFA code>
 function aws-switch-env {    
     aws-reset-env

     if [[ "$1" == "prod" ]]
     then
        export AWS_ENV="prod"
        export AWS_PROFILE=prod
     else
        export AWS_ENV="stage"
        export AWS_PROFILE=stage
     fi

     AWS_MFA=$2
     echo $AWS_PROFILE
     aws-mfa-session $AWS_ENV $AWS_MFA
     echo -e $AWS_ENV
     aws-whoami
 }

