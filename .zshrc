typeset -U path PATH   # dedupe PATH so re-sourcing doesn't grow it
export PATH=/opt/homebrew/opt/openjdk@17/bin:$PATH

# ==============================================================================
# ~/.zshrc  (macOS adaptation of the Arch .bashrc)
# ==============================================================================

# Exit early if not running interactively
[[ $- != *i* ]] && return

BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# ------------------------------------------------------------------------------
# History & Completion
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive tab

# Up/Down arrow: search history by what you've already typed (e.g. "git" + ↑)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

# ------------------------------------------------------------------------------
# Default Command Enhancements
# ------------------------------------------------------------------------------
# macOS ships BSD ls: use -G for color instead of --color=auto
export CLICOLOR=1
alias ls='ls -G'
alias la='ls -alhG'
alias grep='grep --color=auto'          # BSD grep supports --color=auto
alias ..='cd ..'
alias editor='open -e'                   # TextEdit; swap for: code / nano / nvim
alias ai='ollama run deepseek-coder:6.7b'
alias reload='source ~/.zshrc && echo "zshrc reloaded"'

mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# ------------------------------------------------------------------------------
# Modern CLI Tools (each block only activates if the tool is installed)
# ------------------------------------------------------------------------------
# eza: ls with icons + git status (icons need a Nerd Font in your terminal)
if (( $+commands[eza] )); then
  alias ls='eza --icons --group-directories-first'
  alias la='eza -alh --icons --git --group-directories-first'
  alias lt='eza --tree --level=2 --icons --git-ignore'
  # File-type colors: folders blue, Swift/Xcode orange, JS yellow, TS cyan,
  # images purple, Kotlin/Java pink/red, lock & plist files dimmed
  export EZA_COLORS='di=1;34:*.swift=38;5;208:*.xcodeproj=1;38;5;208:*.xcworkspace=1;38;5;208:*.storyboard=38;5;208:*.xib=38;5;208:*.js=33:*.jsx=33:*.mjs=33:*.cjs=33:*.ts=36:*.tsx=36:*.json=93:*.md=97:*.png=35:*.jpg=35:*.jpeg=35:*.gif=35:*.svg=35:*.webp=35:*.kt=95:*.java=91:*.gradle=32:*.kts=32:*.sh=92:*.zsh=92:*.yml=94:*.yaml=94:*.lock=90:*.plist=90:*.apk=1;32:*.aab=1;32:*.ipa=1;32'
fi

# bat: cat with syntax highlighting (behaves like plain cat in pipes)
if (( $+commands[bat] )); then
  alias cat='bat --paging=never --style=plain'
  # Colored man pages (headings, flags and options highlighted)
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT='-c'
fi

# fzf: Ctrl+R fuzzy history, Ctrl+T fuzzy file picker, Alt+C fuzzy cd
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
  export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border
    --color=hl:blue,hl+:bright-blue,pointer:magenta,marker:yellow,prompt:green,info:8,border:8,spinner:cyan'
  # Ctrl+T: preview files with syntax highlighting (folders as a tree)
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {} 2>/dev/null || eza --tree --level=2 --icons --color=always {}' --preview-window=right:55%"
  # Alt+C: preview each folder as a tree
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}' --preview-window=right:55%"
fi

# zoxide: "z linux" jumps to ~/sandip/LINUX (learns your most-used folders)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# ------------------------------------------------------------------------------
# System & Package Management (Homebrew replaces pacman)
# ------------------------------------------------------------------------------
alias p='brew'
alias 1='brew update && brew upgrade'    # was: pacman -Syu
alias 2='brew cleanup'                   # was: pacman -Sc
alias 5='brew cleanup -s && echo "Homebrew cache cleaned."'

# ------------------------------------------------------------------------------
# Power Management
# ------------------------------------------------------------------------------
alias 0='sudo shutdown -h now'
alias 0r='sudo shutdown -r now'

# ------------------------------------------------------------------------------
# Memory & Cache Cleanup
# ------------------------------------------------------------------------------
# /proc/sys/vm/drop_caches does not exist on macOS; closest equivalent is purge
alias 3='sudo purge && echo "Memory purged."'
alias 4='sudo purge && echo "Memory purged."'
# macOS df has no -T (type); and your nvme partitions do not exist here
alias d='df -h'

# ------------------------------------------------------------------------------
# File Permissions & Private Storage Shortcuts
# ------------------------------------------------------------------------------
# macOS: default group is "staff" (not "users"), and home lives under /Users.
# There is no /home; using a hidden folder in your home dir instead.
alias 6='sudo chmod 777 "$HOME/PERSIONAL" && sudo chown -R '"$USER"':staff "$HOME/PERSIONAL"'
alias 6s='sudo chmod 600 "$HOME/PERSIONAL" && sudo chown -R root:wheel "$HOME/PERSIONAL"'

# ------------------------------------------------------------------------------
# Services & Network (launchctl / networksetup replace systemd + nmcli)
# ------------------------------------------------------------------------------
alias SS='sudo launchctl'
alias 7='brew services start mongodb-community'   # was: systemctl enable mongodb
alias 7s='brew services stop mongodb-community'
# nmcli does not exist; toggle Wi-Fi on the primary interface (usually en0)
alias wifi-on='networksetup -setairportpower en0 on'
alias wifi-off='networksetup -setairportpower en0 off'

alias check-adapter-watt='while true; do date +%T; pmset -g adapter | grep -E "Watts|Wattage|Voltage"; sleep 2; done'

# port [N]: kill whatever is listening on port N (default 8081 = Metro)
port() {
  local p=${1:-8081} pids
  pids=$(lsof -ti tcp:$p)
  if [[ -z $pids ]]; then echo "Nothing running on port $p"; return 0; fi
  echo $pids | xargs kill -9 && echo "Killed PID(s) ${pids//$'\n'/ } on port $p"
}

# ------------------------------------------------------------------------------
# Git Helpers
# ------------------------------------------------------------------------------
# gco: fuzzy-pick a branch (local or remote, newest first) and switch to it
gco() {
  local b
  b=$(git branch --all --sort=-committerdate --format='%(refname:short)' 2>/dev/null \
      | grep -vxE 'origin|.*HEAD.*' \
      | fzf --prompt='Branch> ') || return
  git switch "${b#origin/}"
}

# ------------------------------------------------------------------------------
# Scripts & Development Tools
# ------------------------------------------------------------------------------
alias 8='sh ~/scripts/gitpullrequest.sh'
alias 10='pkill -9 java'
alias lgnative='adb logcat -s ReactNativeJS'

# adbr [N]: let a USB-connected phone reach Metro on your Mac (default 8081)
adbr() { adb reverse tcp:${1:-8081} tcp:${1:-8081} && echo "adb reverse tcp:${1:-8081} OK"; }

# emu: pick an Android emulator from a list and boot it in the background
emu() {
  local avd
  avd=$(emulator -list-avds | fzf --prompt='Emulator> ') || return
  ( emulator -avd "$avd" >/dev/null 2>&1 & )
  echo "Booting $avd..."
}

# ------------------------------------------------------------------------------
# React Native & Monorepo Shortcuts
# ------------------------------------------------------------------------------
# Gradle steps run in a ( subshell ) so a failed build never leaves you in android/
rn_clean() {
  local project_path=$(pwd)
  if [ -d "android" ]; then
    rm -rf android/.gradle android/.kotlin android/app/.cxx android/app/build android/build
  fi
  rm -rf node_modules
  echo "Cleaned Android cache and node_modules for: $project_path"
  pnpm i
}
alias rn='rn_clean'
alias rn1='pnpm start'
alias rn2='pnpm android'
alias rn3='npx react-native log-android'
alias rn4='( cd android && ./gradlew clean ) && pkill -9 java'
alias rn5='( cd android && ./gradlew assembleRelease ) && pkill -9 java'
alias rn6='( cd android && ./gradlew assembleDebug ) && pkill -9 java'

# ------------------------------------------------------------------------------
# Expo Commands (nautilus -> open for the file manager)
# ------------------------------------------------------------------------------

# === RELEASE APK BUILDS (.apk) ===
ex_release_install() {
  npx expo prebuild --clean --platform android &&
  ( cd android && ./gradlew assembleRelease -PreactNativeArchitectures=arm64-v8a &&
    adb install app/build/outputs/apk/release/app-release.apk )
}
alias ex1='ex_release_install'
alias ex-release-install='ex_release_install'

ex_release_open() {
  npx expo prebuild --clean --platform android &&
  ( cd android && ./gradlew assembleRelease -PreactNativeArchitectures=arm64-v8a &&
    open app/build/outputs/apk/release/ )
}
alias ex1o='ex_release_open'
alias ex-release-open='ex_release_open'

# === DEBUG APK BUILDS (.apk) ===
ex_debug_install() {
  npx expo prebuild --clean --platform android &&
  ( cd android && ./gradlew assembleDebug -PreactNativeArchitectures=arm64-v8a &&
    adb install app/build/outputs/apk/debug/app-debug.apk )
}
alias ex2='ex_debug_install'
alias ex-debug-install='ex_debug_install'

ex_debug_open() {
  npx expo prebuild --clean --platform android &&
  ( cd android && ./gradlew assembleDebug -PreactNativeArchitectures=arm64-v8a &&
    open app/build/outputs/apk/debug/ )
}
alias ex2o='ex_debug_open'
alias ex-debug-open='ex_debug_open'

# === ANDROID APP BUNDLE BUILDS (.aab for Play Store) ===
ex_bundle_release() {
  npx expo prebuild --clean --platform android &&
  ( cd android && ./gradlew bundleRelease && open app/build/outputs/bundle/release/ )
}
alias ex3='ex_bundle_release'
alias ex-bundle-release='ex_bundle_release'

ex_bundle_debug() {
  npx expo prebuild --clean --platform android &&
  ( cd android && ./gradlew bundleDebug && open app/build/outputs/bundle/debug/ )
}
alias ex3d='ex_bundle_debug'
alias ex-bundle-debug='ex_bundle_debug'

# ------------------------------------------------------------------------------
# Environment Variables & Android SDK (macOS SDK path)
# ------------------------------------------------------------------------------
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# ------------------------------------------------------------------------------
# Prompt
#   Divider: ─────────── ✘ 127 not found  took 12.3s  14:32 ──
#   Line 1:  ~/parent/CURRENT (branch) +1 ~2 ?1 ↑1  ⬢ node 24.22  🐦 swift 6.4  📱 device
#   Line 2:  ▶                                           [battery  clock on the right]
# ------------------------------------------------------------------------------
setopt PROMPT_SUBST
autoload -Uz vcs_info add-zsh-hook
zmodload zsh/datetime

# --- Command timer + desktop notification (registered first so it sees $?) ---
_t_start() { _t0=$EPOCHREALTIME; _t_cmd=${1%% *}; }
# Human-readable duration: 5.6s / 16m 9s / 1h 2m
_fmt_dur() {
  local -i s=$1
  if   (( $1 < 60 ));   then REPLY=$(printf '%.1fs' $1)
  elif (( s < 3600 )); then REPLY="$(( s / 60 ))m $(( s % 60 ))s"
  else                      REPLY="$(( s / 3600 ))h $(( s % 3600 / 60 ))m"
  fi
}
_t_end() {
  local st=$?
  _last_status=$st _took='' _ran_cmd=0
  [[ -z $_t0 ]] && return          # empty Enter: nothing ran
  _ran_cmd=1
  local d=$(( EPOCHREALTIME - _t0 )); unset _t0
  _fmt_dur $d
  (( d > 3 )) && _took=$REPLY
  # Long command (>30s) finished: macOS notification, so you can switch away
  if (( d > 30 )); then
    local icon='✅' word='finished'
    (( st != 0 )) && { icon='❌'; word='failed'; }
    osascript -e "display notification \"${icon} ${_t_cmd//\"/} ${word} in ${REPLY}\" with title \"Terminal\"" &>/dev/null &!
  fi
}
add-zsh-hook preexec _t_start
add-zsh-hook precmd _t_end

# --- Git: branch + file counts + ahead/behind arrows ---
#   +3 green  = 3 files staged (git add done)
#   ~2 yellow = 2 files modified, not staged yet
#   ?1 red    = 1 new untracked file
#   ↑2 / ↓1   = commits ahead of / behind the remote
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f%m'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%F{red}%a%F{yellow})%f%m'
zstyle ':vcs_info:git*+set-message:*' hooks git-aheadbehind
+vi-git-aheadbehind() {
  local line staged=0 modified=0 untracked=0
  for line in ${(f)"$(git status --porcelain 2>/dev/null)"}; do
    if [[ $line == '??'* ]]; then (( untracked++ ))
    else
      [[ ${line[1]} == [MADRCU] ]] && (( staged++ ))
      [[ ${line[2]} == [MDU] ]] && (( modified++ ))
    fi
  done
  (( staged ))    && hook_com[misc]+=" %F{green}+${staged}%f"
  (( modified ))  && hook_com[misc]+=" %F{yellow}~${modified}%f"
  (( untracked )) && hook_com[misc]+=" %F{red}?${untracked}%f"
  local ahead behind
  read ahead behind <<< "$(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)"
  (( ahead ))  && hook_com[misc]+=" %F{green}↑${ahead}%f"
  (( behind )) && hook_com[misc]+=" %F{red}↓${behind}%f"
}
add-zsh-hook precmd vcs_info

# --- Project badge: node version (cached per folder) + connected Android device ---
_proj_node() {
  _node_badge=''
  [[ -f package.json ]] && (( $+commands[node] )) || return
  local v=$(node -v 2>/dev/null); v=${v#v}
  _node_badge=" %F{green}⬢ node ${v%.*}%f"
}
_proj_device() {
  _dev_badge=''
  # Only in JS projects, and only if the adb server is already running (never starts it)
  [[ -n $_node_badge ]] && pgrep -xq adb || return
  local -a devs
  devs=(${(f)"$(adb devices -l 2>/dev/null | awk '/ device /{for(i=1;i<=NF;i++) if($i~/^model:/){sub("model:","",$i); print $i}}')"})
  (( ${#devs} )) || return
  _dev_badge=" %F{blue}📱 ${devs[1]}%f"
  (( ${#devs} > 1 )) && _dev_badge+="%F{blue} +$(( ${#devs} - 1 ))%f"
}
add-zsh-hook chpwd _proj_node
add-zsh-hook precmd _proj_device
_proj_node   # run once for the folder the shell starts in

# --- Swift badge: shown in folders with Package.swift / .xcodeproj / .xcworkspace ---
# "swift --version" takes ~1s, so the result is cached in ~/.cache and only
# re-checked when the active Xcode (xcode-select -p) changes or gets updated.
_swift_version() {
  (( $+commands[swift] )) || return 1
  local dev=$(xcode-select -p 2>/dev/null) cache=~/.cache/zsh-swift-version
  zmodload -F zsh/stat b:zstat
  local -a mt; zstat -A mt +mtime -- "$dev" 2>/dev/null
  local key="$dev:${mt[1]}"
  if [[ -r $cache ]]; then
    local -a c=("${(@f)$(<$cache)}")
    [[ ${c[1]} == $key ]] && { REPLY=${c[2]}; return 0; }
  fi
  local out=$(swift --version 2>/dev/null)
  [[ $out =~ 'Swift version ([0-9]+\.[0-9]+)' ]] || return 1
  REPLY=${match[1]}
  mkdir -p ~/.cache && print -r -- "$key"$'\n'"$REPLY" >| $cache
}
_proj_swift() {
  _swift_badge=''
  local -a hits=( Package.swift(N) *.xcodeproj(N) *.xcworkspace(N) )
  (( ${#hits} )) || return
  [[ -z $_swift_ver ]] && _swift_version && _swift_ver=$REPLY
  [[ -n $_swift_ver ]] && _swift_badge=" %F{208}🐦 swift ${_swift_ver}%f"
}
add-zsh-hook chpwd _proj_swift
_proj_swift

# --- Terminal tab title: folder when idle, command while running ---
_title_idle() { print -Pn '\e]0;%1~\a'; }
_title_cmd()  { print -rn -- $'\e]0;'"${1[1,50]}"$'\a'; }
add-zsh-hook precmd _title_idle
add-zsh-hook preexec _title_cmd

# --- Divider after each command: ──────── ✘ 127 not found  took 16m 9s  14:32 ──
# Printed (not part of the prompt), so status + duration stay in scrollback.
_divider() {
  (( _ran_cmd )) || return
  local label='' plain='' why=''
  if (( _last_status )); then
    case $_last_status in
      126) why=' not executable';; 127) why=' not found';;
      130) why=' Ctrl+C';;         137) why=' killed';;
    esac
    label+="%F{red}✘ ${_last_status}${why}%f  "; plain+="✘ ${_last_status}${why}  "
  fi
  [[ -n $_took ]] && { label+="%F{yellow}took ${_took}%f  "; plain+="took ${_took}  "; }
  local now=${(%):-%D{%H:%M}}
  label+="%F{244}${now}%f"; plain+=$now
  local -i n=$(( COLUMNS - ${#plain} - 4 )); (( n < 4 )) && n=4
  print -P -- "%F{238}${(l:n::─:)}%f ${label} %F{238}──%f"
}

# --- Path: parent folders dimmed, current folder bold ---
_build_path() {
  local p=${(%):-%~}; p=${p//\%/%%}
  if [[ $p == */* && $p != / ]]; then
    _path="%F{244}${p%/*}/%f%B%F{cyan}${p##*/}%f%b"
  else
    _path="%B%F{cyan}${p}%f%b"
  fi
}

# --- Battery (right side), refreshed at most once a minute; empty on desktops ---
_batt_update() {
  (( EPOCHSECONDS - ${_batt_ts:-0} < 60 )) && return
  _batt_ts=$EPOCHSECONDS _batt=''
  local out=$(pmset -g batt 2>/dev/null)
  [[ $out =~ '([0-9]+)%' ]] || return
  local -i pct=${match[1]}; local col=green icon=$''      # Nerd Font battery
  (( pct < 50 )) && { col=yellow icon=$''; }
  (( pct < 20 )) && { col=red    icon=$''; }
  [[ $out == *"'AC Power'"* ]] && icon=$''                # Nerd Font bolt
  _batt="%F{$col}${icon} ${pct}%%%f  "
}

# --- Prompt layout ---
_PROMPT_FULL='${_path}${vcs_info_msg_0_}${_node_badge}${_swift_badge}${_dev_badge}
%(?.%F{green}.%F{red})▶%f '
_RPROMPT_FULL='${_batt}%F{244}%D{%H:%M}%f'
_build_prompt() {
  _divider
  _build_path
  _batt_update
  PROMPT=$_PROMPT_FULL RPROMPT=$_RPROMPT_FULL
  print -n '\e[5 q'                    # blinking bar cursor
}
add-zsh-hook precmd _build_prompt

# --- Welcome banner (once per new terminal, not on reload) ---
_banner() {
  local os=$(sw_vers -productVersion 2>/dev/null)
  local chip=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)
  local -i total=$(( $(sysctl -n hw.memsize) / 1073741824 ))
  local vm=$(vm_stat) l; local -A v; local -i ps=16384
  [[ $vm =~ 'page size of ([0-9]+)' ]] && ps=${match[1]}
  for l in ${(f)vm}; do
    [[ $l =~ '^"?([^:"]+)"?:[[:space:]]+([0-9]+)' ]] && v[${match[1]}]=${match[2]}
  done
  local used=$(printf '%.1f' $(( (${v[Pages active]:-0} + ${v[Pages wired down]:-0} + ${v[Pages occupied by compressor]:-0}) * ps / 1073741824.0 )))
  local -i free=$(( $(df -k /System/Volumes/Data | awk 'NR==2{print $4}') * 1024 / 1000000000 ))
  _batt_update
  local sep='%F{238}  ·  %f'
  print -P -- "%F{white}macOS ${os}%f${sep}%F{cyan}${chip}%f${sep}%F{244}RAM%f %F{white}${used}/${total} GB%f${sep}%F{244}Disk%f %F{white}${free} GB free%f${sep}${_batt% }"
}
[[ -z $_BANNER_SHOWN ]] && { _banner; _BANNER_SHOWN=1; }

xcode26() { nohup /Applications/Xcode-26.5.app/Contents/MacOS/Xcode "$@" >/dev/null 2>&1 & }

# ------------------------------------------------------------------------------
# Autosuggestions + Syntax Highlighting (syntax-highlighting MUST stay last)
# ------------------------------------------------------------------------------
[[ -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# Folder-aware suggestions: for "cd ...", only suggest history entries whose
# folder exists from where you are now; otherwise fall back to tab-completion.
_zsh_autosuggest_strategy_smart_history() {
  emulate -L zsh
  setopt EXTENDED_GLOB
  if [[ $1 != cd\ * ]]; then
    _zsh_autosuggest_strategy_history "$1"
    return
  fi
  local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}"
  local k h dir
  for k in ${(On)${(k)history[(R)$prefix*]}}; do   # newest first
    h=$history[$k]
    dir=${(Q)${(z)h}[2]}
    [[ $dir == '~'* ]] && dir=$HOME${dir#\~}
    if [[ -z $dir || $dir == - || -d $dir ]]; then
      typeset -g suggestion=$h
      return
    fi
  done
}
ZSH_AUTOSUGGEST_STRATEGY=(smart_history completion)
[[ -f $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
