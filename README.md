# LINUX

My personal Linux dotfiles and notes, for an Arch Linux machine used for React Native / Expo development.

## Contents

| File | Description |
| --- | --- |
| [`.bashrc`](.bashrc) | Bash config: aliases, helper functions, Android SDK paths and a coloured prompt |
| [`gitCommands`](gitCommands) | Quick reference of the git commands used to set up and push repos |

## Installation

```bash
git clone https://github.com/sandipkumar681/LINUX.git
cp ~/.bashrc ~/.bashrc.backup        # back up your existing config
cp LINUX/.bashrc ~/.bashrc
source ~/.bashrc
```

> **Note:** Some aliases contain machine-specific paths and names (`/dev/nvme0n1p3`, `soulbuster`, `~/scripts/gitpullrequest.sh`, `PERSIONAL`). Edit them before using this on another machine.

## Aliases

### General

| Alias | Command |
| --- | --- |
| `ls` | `ls --color=auto` |
| `la` | `ls -alh` |
| `grep` | `grep --color=auto` |
| `..` | `cd ..` |
| `editor` | Open GNOME Text Editor |
| `ai` | `ollama run deepseek-coder:6.7b` |

### System and packages (pacman)

| Alias | Action |
| --- | --- |
| `p` | `sudo pacman` |
| `1` | Full system upgrade (`pacman -Syu`) |
| `2` | Remove uninstalled packages from the cache (`pacman -Sc`) |
| `5` | Delete the entire pacman package cache |
| `0` | Shut down now |
| `0r` | Reboot now |

### Memory and disk

| Alias | Action |
| --- | --- |
| `3` | Drop the page cache |
| `4` | Drop page cache, dentries and inodes |
| `d` | Show disk usage for the main NVMe partitions |

### Private folder

| Alias | Action |
| --- | --- |
| `6` | Unlock `PERSIONAL`: make it user-owned and move it to `~` |
| `6s` | Lock `PERSIONAL`: make it root-owned (`600`) and move it back to `/home` |

### Services and network

| Alias | Action |
| --- | --- |
| `SS` | `sudo systemctl` |
| `7` / `7s` | Enable / disable `mongodb.service` |
| `wifi` | `nmcli radio wifi` (append `on` / `off`) |

### Development

| Alias | Action |
| --- | --- |
| `8` | Run `~/scripts/gitpullrequest.sh` |
| `10` | Kill all Java processes (stops Gradle daemons) |
| `lgnative` | Show React Native JS logs via `adb logcat` |

### React Native

| Alias | Action |
| --- | --- |
| `rn` | Delete Android build caches and `node_modules`, then `pnpm i` |
| `rn1` | `pnpm start` (Metro) |
| `rn2` | `pnpm android` |
| `rn3` | `npx react-native log-android` |
| `rn4` | `./gradlew clean` |
| `rn5` | Build a release APK |
| `rn6` | Build a debug APK |

### Expo (Android)

Each of these runs `npx expo prebuild --clean` first, then builds with Gradle.

| Alias | Long name | Output |
| --- | --- | --- |
| `ex1` | `ex-release-install` | Release APK (arm64), installed via `adb` |
| `ex1o` | `ex-release-open` | Release APK (arm64), opens the output folder |
| `ex2` | `ex-debug-install` | Debug APK (arm64), installed via `adb` |
| `ex2o` | `ex-debug-open` | Debug APK (arm64), opens the output folder |
| `ex3` | `ex-bundle-release` | Release AAB for the Play Store, opens the output folder |
| `ex3d` | `ex-bundle-debug` | Debug AAB, opens the output folder |

## Environment

- `ANDROID_HOME` is set to `~/Android/Sdk`, and the `emulator`, `platform-tools` and `cmdline-tools` directories are added to `PATH`.
- The prompt shows `user@host:directory>` in cyan, green and purple.

## Requirements

Arch Linux (pacman), `pnpm`, Node.js / `npx`, the Android SDK, `adb`, Nautilus, GNOME Text Editor and, optionally, Ollama and MongoDB.
