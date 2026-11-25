export PATH=/opt/homebrew/opt/openjdk@17/bin:$PATH

# ==============================================================================
# ~/.zshrc  (macOS adaptation of the Arch .bashrc)
# ==============================================================================

# Exit early if not running interactively
[[ $- != *i* ]] && return

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

# ------------------------------------------------------------------------------
# Scripts & Development Tools
# ------------------------------------------------------------------------------
alias 8='sh ~/scripts/gitpullrequest.sh'
alias 10='pkill -9 java'
alias lgnative='adb logcat -s ReactNativeJS'

# ------------------------------------------------------------------------------
# React Native & Monorepo Shortcuts (cross-platform, unchanged)
# ------------------------------------------------------------------------------
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
alias rn4='cd android && ./gradlew clean && 10 && cd ..'
alias rn5='cd android && ./gradlew assembleRelease && 10 && cd ..'
alias rn6='cd android && ./gradlew assembleDebug && 10 && cd ..'

# ------------------------------------------------------------------------------
# Expo Commands (nautilus -> open for the file manager)
# ------------------------------------------------------------------------------

# === RELEASE APK BUILDS (.apk) ===
ex_release_install() {
  npx expo prebuild --clean --platform android && cd android && ./gradlew assembleRelease -PreactNativeArchitectures=arm64-v8a && adb install app/build/outputs/apk/release/app-release.apk && cd ..
}
alias ex1='ex_release_install'
alias ex-release-install='ex_release_install'

ex_release_open() {
  npx expo prebuild --clean --platform android && cd android && ./gradlew assembleRelease -PreactNativeArchitectures=arm64-v8a && open app/build/outputs/apk/release/ && cd ..
}
alias ex1o='ex_release_open'
alias ex-release-open='ex_release_open'

# === DEBUG APK BUILDS (.apk) ===
ex_debug_install() {
  npx expo prebuild --clean --platform android && cd android && ./gradlew assembleDebug -PreactNativeArchitectures=arm64-v8a && adb install app/build/outputs/apk/debug/app-debug.apk && cd ..
}
alias ex2='ex_debug_install'
alias ex-debug-install='ex_debug_install'

ex_debug_open() {
  npx expo prebuild --clean --platform android && cd android && ./gradlew assembleDebug -PreactNativeArchitectures=arm64-v8a && open app/build/outputs/apk/debug/ && cd ..
}
alias ex2o='ex_debug_open'
alias ex-debug-open='ex_debug_open'

# === ANDROID APP BUNDLE BUILDS (.aab for Play Store) ===
ex_bundle_release() {
  npx expo prebuild --clean --platform android && cd android && ./gradlew bundleRelease && open app/build/outputs/bundle/release/ && cd ..
}
alias ex3='ex_bundle_release'
alias ex-bundle-release='ex_bundle_release'

ex_bundle_debug() {
  npx expo prebuild --clean --platform android && cd android && ./gradlew bundleDebug && open app/build/outputs/bundle/debug/ && cd ..
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
# Prompt Styling (zsh PROMPT: Cyan user @ Green host : Purple directory)
# ------------------------------------------------------------------------------
autoload -U colors && colors
export PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{magenta}%~%f> '

xcode26() { nohup /Applications/Xcode-26.5.app/Contents/MacOS/Xcode "$@" >/dev/null 2>&1 & }
