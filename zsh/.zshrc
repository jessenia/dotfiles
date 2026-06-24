# ============================================================
# Powerlevel10k instant prompt
# Must stay close to the top of ~/.zshrc.
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# Core environment
# ============================================================
export EDITOR="${EDITOR:-nvim}"
export ZSH="$HOME/.oh-my-zsh"

# Deduplicate PATH entries
typeset -U path PATH

# User-local binaries
path+=("$HOME/.local/bin")

# Homebrew / YubiKey agent
if command -v brew >/dev/null 2>&1; then
  export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"
fi

# ============================================================
# Oh My Zsh
# ============================================================
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  docker
  1password
  ansible
  aws
  brew
  vscode
  common-aliases
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ============================================================
# Key bindings
# Force emacs-style line editing. zsh otherwise auto-selects *vi* mode
# because $EDITOR ("nvim") contains "vi", which makes typed letters behave
# as vi motions after Esc. Use `bindkey -v` here if you actually want vi mode.
# ============================================================
bindkey -e

# ============================================================
# Completion
# ============================================================
if command -v terraform >/dev/null 2>&1; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C "$(command -v terraform)" terraform
fi

# ============================================================
# Personal aliases / local config
# ============================================================
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.local.zsh" ]] && source "$HOME/.local.zsh"

# ============================================================
# Powerlevel10k config
# ============================================================
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ============================================================
# AWS helpers
# ============================================================
typeset -gA AWS_ENV_PROFILES=(
  [dev]="dev"
  [stage]="stage"
  [prod]="prod"
)

aws-clear-env() {
  unset AWS_ENV
  unset AWS_PROFILE
  unset AWS_DEFAULT_PROFILE
  unset AWS_REGION
  unset AWS_DEFAULT_REGION

  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  unset AWS_SECURITY_TOKEN
  unset AWS_SESSION_EXPIRY
  unset AWS_ASSUMED_ROLE_ID
  unset AWS_ASSUMED_ROLE_ARN

  echo "AWS environment cleared."
}

aws-env-list() {
  echo "Configured AWS environment mappings:"
  for env in ${(k)AWS_ENV_PROFILES}; do
    echo "  ${env} -> ${AWS_ENV_PROFILES[$env]}"
  done

  echo
  echo "Available AWS CLI profiles:"
  aws configure list-profiles 2>/dev/null || echo "Unable to list AWS profiles."
}

aws-whoami() {
  if ! command -v aws >/dev/null 2>&1; then
    echo "aws CLI not found."
    return 127
  fi

  local profile="${AWS_PROFILE:-default}"
  local region="${AWS_REGION:-${AWS_DEFAULT_REGION:-$(aws configure get region --profile "$profile" 2>/dev/null)}}"

  echo "AWS_ENV=${AWS_ENV:-<unset>}"
  echo "AWS_PROFILE=${AWS_PROFILE:-<default>}"
  echo "AWS_REGION=${region:-<unset>}"
  echo

  aws sts get-caller-identity --output table
}

aws-env() {
  local env_name="$1"

  case "$env_name" in
    ""|show|current)
      aws-whoami
      return
      ;;
    list)
      aws-env-list
      return
      ;;
    clear|reset|unset)
      aws-clear-env
      return
      ;;
  esac

  local profile="${AWS_ENV_PROFILES[$env_name]}"

  if [[ -z "$profile" ]]; then
    echo "Unknown AWS environment: $env_name"
    echo
    aws-env-list
    return 1
  fi

  export AWS_ENV="$env_name"
  export AWS_PROFILE="$profile"
  unset AWS_DEFAULT_PROFILE

  echo "Switched AWS environment:"
  echo "AWS_ENV=${AWS_ENV}"
  echo "AWS_PROFILE=${AWS_PROFILE}"
  echo

  aws-whoami
}

aws-profile() {
  local profile="$1"

  case "$profile" in
    ""|show|current)
      aws-whoami
      return
      ;;
    list)
      aws configure list-profiles
      return
      ;;
    clear|reset|unset)
      aws-clear-env
      return
      ;;
  esac

  export AWS_PROFILE="$profile"
  unset AWS_ENV
  unset AWS_DEFAULT_PROFILE

  echo "Switched AWS profile:"
  echo "AWS_PROFILE=${AWS_PROFILE}"
  echo

  aws-whoami
}

aws-login() {
  local profile="${1:-${AWS_PROFILE:-default}}"

  if ! command -v aws >/dev/null 2>&1; then
    echo "aws CLI not found."
    return 127
  fi

  local sso_session
  local sso_start_url

  sso_session="$(aws configure get sso_session --profile "$profile" 2>/dev/null)"
  sso_start_url="$(aws configure get sso_start_url --profile "$profile" 2>/dev/null)"

  if [[ -n "$sso_session" || -n "$sso_start_url" ]]; then
    aws sso login --profile "$profile"
  else
    echo "No SSO config detected for profile: $profile"
    echo "Testing current credentials instead..."
    aws sts get-caller-identity --profile "$profile"
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
