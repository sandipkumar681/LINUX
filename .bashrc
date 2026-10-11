# ==============================================================================
# ~/.bashrc
# ==============================================================================

# Exit early if not running interactively
[[ $- != *i* ]] && return

# ------------------------------------------------------------------------------
# Default Command Enhancements
# ------------------------------------------------------------------------------
alias ls='ls --color=auto'
alias la='ls -alh'
alias grep='grep --color=auto'
alias ..='cd ..'
alias editor='gnome-text-editor'
alias ai='ollama run deepseek-coder:6.7b'

# ------------------------------------------------------------------------------
# System & Package Management (Arch / Pacman)
# ------------------------------------------------------------------------------
alias p='sudo pacman'
alias 1='sudo pacman -Syu'
alias 2='sudo pacman -Sc'
alias 5='cd /var/cache/pacman && sudo rm -rf pkg/* && echo "Pacman cache cleaned." && cd - > /dev/null'

# ------------------------------------------------------------------------------
# Power Management
# ------------------------------------------------------------------------------
alias 0='shutdown now'
alias 0r='shutdown -r now'

# ------------------------------------------------------------------------------
# Memory & Cache Cleanup
# ------------------------------------------------------------------------------
alias 3='sudo sh -c "echo 1 > /proc/sys/vm/drop_caches" && echo "REMOVED UNNECESSARY CACHE"'
alias 4='sudo sh -c "echo 3 > /proc/sys/vm/drop_caches" && echo "REMOVED UNNECESSARY CACHE & UNUSED RAM SPACE"'
alias d='df -Th | grep -E "Filesystem|/dev/nvme0n1p3|/dev/nvme0n1p4"'

# ------------------------------------------------------------------------------
# File Permissions & Private Storage Shortcuts
# ------------------------------------------------------------------------------
alias 6='cd /home && sudo chmod 777 PERSIONAL && sudo chown soulbuster:users -R PERSIONAL && sudo mv PERSIONAL ~/ && cd ~/'
alias 6s='cd ~/ && sudo chmod 600 PERSIONAL && sudo chown -R root:root PERSIONAL && sudo mv PERSIONAL /home'

# ------------------------------------------------------------------------------
# Systemd Services & Network
# ------------------------------------------------------------------------------
alias SS='sudo systemctl'
alias 7='sudo systemctl enable mongodb.service'
alias 7s='sudo systemctl disable mongodb.service'
alias wifi='nmcli radio wifi'

# ------------------------------------------------------------------------------
# Scripts & Development Tools
# ------------------------------------------------------------------------------
alias 8='sh ~/scripts/gitpullrequest.sh'
alias 10='pkill -9 java'
alias lgnative='adb logcat -s ReactNativeJS'

# ------------------------------------------------------------------------------
# React Native & Monorepo Shortcuts
# ------------------------------------------------------------------------------
# Deep clean Android build artifacts and re-install node_modules using pnpm
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
# Expo Commands (Expo CLI - Distinct 'ex' prefix)
# ------------------------------------------------------------------------------

# === RELEASE APK BUILDS (.apk) ===

# Expo Release APK: Prebuild, Assemble Release APK & Install via ADB
ex_release_install() {
  npx expo prebuild --clean && cd android && ./gradlew assembleRelease -PreactNativeArchitectures=arm64-v8a && adb install app/build/outputs/apk/release/app-release.apk && cd ..
}
alias ex1='ex_release_install'
alias ex-release-install='ex_release_install'

# Expo Release APK: Prebuild, Assemble Release APK & Open folder in Nautilus
ex_release_open() {
  npx expo prebuild --clean && cd android && ./gradlew assembleRelease -PreactNativeArchitectures=arm64-v8a && nautilus app/build/outputs/apk/release/ && cd ..
}
alias ex1o='ex_release_open'
alias ex-release-open='ex_release_open'


# === DEBUG APK BUILDS (.apk) ===

# Expo Debug APK: Prebuild, Assemble Debug APK & Install via ADB
ex_debug_install() {
  npx expo prebuild --clean && cd android && ./gradlew assembleDebug -PreactNativeArchitectures=arm64-v8a && adb install app/build/outputs/apk/debug/app-debug.apk && cd ..
}
alias ex2='ex_debug_install'
alias ex-debug-install='ex_debug_install'

# Expo Debug APK: Prebuild, Assemble Debug APK & Open folder in Nautilus
ex_debug_open() {
  npx expo prebuild --clean && cd android && ./gradlew assembleDebug -PreactNativeArchitectures=arm64-v8a && nautilus app/build/outputs/apk/debug/ && cd ..
}
alias ex2o='ex_debug_open'
alias ex-debug-open='ex_debug_open'


# === ANDROID APP BUNDLE BUILDS (.aab for Play Store) ===

# Expo Bundle Release: Prebuild, Assemble Release AAB & Open folder in Nautilus
ex_bundle_release() {
  npx expo prebuild --clean && cd android && ./gradlew bundleRelease && nautilus app/build/outputs/bundle/release/ && cd ..
}
alias ex3='ex_bundle_release'
alias ex-bundle-release='ex_bundle_release'

# Expo Bundle Debug: Prebuild, Assemble Debug AAB & Open folder in Nautilus
ex_bundle_debug() {
  npx expo prebuild --clean && cd android && ./gradlew bundleDebug && nautilus app/build/outputs/bundle/debug/ && cd ..
}
alias ex3d='ex_bundle_debug'
alias ex-bundle-debug='ex_bundle_debug'

# ------------------------------------------------------------------------------
# Environment Variables & Android SDK
# ------------------------------------------------------------------------------
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# ------------------------------------------------------------------------------
# Prompt Styling (Cyan user @ Green host : Purple directory)
# ------------------------------------------------------------------------------
export PS1='\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\]> '

